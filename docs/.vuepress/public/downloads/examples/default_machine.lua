-- GWO animation API 1. Reusable policy; copy into a pack and require it by namespace.
local M = {}

local function count(t)
    local n = 0
    for _ in pairs(t or {}) do n = n + 1 end
    return n
end

local function value_matches(actual, expected)
    expected = tostring(expected)
    actual = actual == nil and nil or tostring(actual)
    if expected == "*" then return actual ~= nil and actual ~= "" end
    if expected == "!" then return actual == nil or actual == "" end
    if expected:sub(1, 1) == "!" and expected:sub(1, 2) ~= "!=" then
        return actual ~= expected:sub(2)
    end
    if expected:find("|", 1, true) then
        for part in expected:gmatch("[^|]+") do
            if value_matches(actual, part:match("^%s*(.-)%s*$")) then return true end
        end
        return false
    end
    local op, number = expected:match("^([<>]=?)(.*)$")
    if op and tonumber(actual) and tonumber(number) then
        local a, b = tonumber(actual), tonumber(number)
        if op == ">" then return a > b end
        if op == "<" then return a < b end
        if op == ">=" then return a >= b end
        if op == "<=" then return a <= b end
    end
    return expected:lower() == (actual or ""):lower()
end

local function matches(when, context)
    for key, expected in pairs(when or {}) do
        if not value_matches(context[key], expected) then return false end
    end
    return true
end

local function ordered(rules, specificity)
    local sorted = {}
    for index, rule in ipairs(rules or {}) do
        sorted[#sorted + 1] = {rule = rule, index = index}
    end
    table.sort(sorted, function(a, b)
        local ap, bp = a.rule.priority or 0, b.rule.priority or 0
        if ap ~= bp then return ap > bp end
        local ac, bc = specificity(a.rule), specificity(b.rule)
        if ac ~= bc then return ac > bc end
        return a.index < b.index
    end)
    return sorted
end

local function expression(expression, values)
    if expression == nil or expression == "*" then return true end
    for candidate in expression:gmatch("[^|]+") do
        candidate = candidate:match("^%s*(.-)%s*$"):lower()
        local negate = candidate:sub(1, 1) == "!"
        if negate then candidate = candidate:sub(2) end
        local found = false
        for _, value in ipairs(values) do if candidate == value:lower() then found = true end end
        if (found and not negate) or (negate and not found) then return true end
    end
    return false
end

function M.new(config)
    local machine = {config = config}
    local actions = config.animation_machine.actions
    local channels = config.animation_controller.channels
    local variants, sequences = {}, {}
    for name, action in pairs(actions) do
        variants[name] = ordered(action.variants, function(r) return count(r.when) end)
        sequences[name] = ordered(action.sequences, function(r) return count(r.when) end)
    end
    local interrupts = ordered(config.animation_machine.interrupts, function(r)
        return (r.active ~= "*" and 1 or 0) + (r.incoming ~= "*" and 1 or 0)
            + (#(r.phases or {}) > 0 and 1 or 0)
            + (((r.min_progress or 0) > 0 or (r.max_progress or 1) < 1) and 1 or 0)
    end)

    function machine.select(action, fallback, context)
        for _, entry in ipairs(variants[action] or {}) do
            local rule = entry.rule
            if (channels[rule.state] or (config.animation_clips or {})[rule.state])
                and matches(rule.when, context) then
                return {state = rule.state, transition = rule.transition or 0}
            end
        end
        return {state = fallback, transition = 0}
    end

    function machine.phase(action, phase, fallback)
        local spec = actions[action]
        if not spec then return fallback end
        return (spec.phase_states or {})[phase] or spec.default_state or fallback
    end

    function machine.plan(action, selected, context, duration)
        local authored = {{state = selected, marker = "shot", phase = "action"}}
        for _, entry in ipairs(sequences[action] or {}) do
            if matches(entry.rule.when, context) then authored = entry.rule.steps; break end
        end
        local steps, events, markers, cursor = {}, {}, {}, 0
        for _, step in ipairs(authored) do
            local ms = math.max(1, duration(step.state))
            local marker = step.marker or step.state
            steps[#steps + 1] = {state = step.state, marker = marker, phase = step.phase or "action",
                time_ms = cursor, duration_ms = ms}
            markers[marker] = markers[marker] or cursor
            markers[step.state] = markers[step.state] or cursor
            cursor = cursor + ms
        end
        local state = authored[#authored] and authored[#authored].state
        local visited = {}
        while state and not visited[state] do
            visited[state] = true
            local next_state = channels[state] and channels[state].next_state
            if not next_state or visited[next_state] or not channels[next_state] or channels[next_state].loop then break end
            cursor = cursor + math.max(1, duration(next_state))
            state = next_state
        end
        markers.action, markers.shot = markers.action or 0, markers.shot or 0
        for _, event in ipairs(actions[action] and actions[action].events or {}) do
            if matches(event.when, context) then
                assert(markers[event.marker or "action"], "Unknown animation marker: " .. tostring(event.marker))
                local time = markers[event.marker or "action"] + (event.offset_ms or 0)
                events[#events + 1] = {type = event.type, time_ms = time, order = #events + 1}
                cursor = math.max(cursor, time + 1)
            end
        end
        table.sort(events, function(a, b)
            if a.time_ms == b.time_ms then return a.order < b.order end
            return a.time_ms < b.time_ms
        end)
        return {duration_ms = math.max(1, cursor), steps = steps, events = events}
    end

    function machine.interrupt(ctx)
        for _, entry in ipairs(interrupts) do
            local r = entry.rule
            local phase_ok = #(r.phases or {}) == 0
            local phases = {}
            for p in ctx.phase:gmatch("[^|]+") do phases[#phases + 1] = p end
            for _, p in ipairs(r.phases or {}) do if expression(p, phases) then phase_ok = true end end
            if ctx.progress >= (r.min_progress or 0) and ctx.progress <= (r.max_progress or 1)
                and expression(r.active, {ctx.active, ctx.active_state, ctx.active_group})
                and expression(r.incoming, {ctx.incoming, ctx.incoming_state, ctx.incoming_group}) and phase_ok
                and r.decision ~= "default" then
                return {decision = r.decision, transition = r.transition or 0, priority = r.priority or 0, reason = r.reason}
            end
        end
        if ctx.melee_enabled and ctx.active_family == "MELEE" and ctx.incoming_family == "MELEE" then
            return {decision = ctx.progress + .00001 < ctx.chain_open_progress and "queue" or "interrupt", transition = .035}
        end
        local from, to = ctx.active_family, ctx.incoming_family
        local aim, sprint = ctx.incoming == "aim", ctx.incoming == "sprint"
        local function result(decision, transition) return {decision = decision, transition = transition or 0} end
        if from == "INSPECT" then
            if to == "FIRE" or to == "RELOAD" or to == "MELEE" or to == "EQUIP" or sprint then return result("interrupt", .04) end
        elseif from == "MODE" or from == "FIRE" then
            if to == "FIRE" or to == "RELOAD" or to == "MELEE" or to == "EQUIP" then return result("interrupt", .03) end
            if sprint or (from == "FIRE" and to == "RECHAMBER") then return result("interrupt", .04) end
            if aim then return result("allow") end
        elseif from == "RELOAD" then
            if to == "EQUIP" then return result("interrupt", .04) end
            if aim then return result("allow") end
        elseif from == "RECHAMBER" then
            if to == "FIRE" then return result("queue", .02) end
            if to == "MELEE" or to == "EQUIP" then return result("interrupt", .04) end
            if aim then return result("allow") end
        elseif from == "MELEE" then
            if to == "EQUIP" then return result("interrupt", .04) end
            if to == "MELEE" then return result("queue", .035) end
        elseif from == "CHARGE" then
            if to == "FIRE" then return result("interrupt", .02) end
            if to == "EQUIP" or to == "MELEE" then return result("interrupt", .04) end
            if aim then return result("allow") end
        elseif from == "EQUIP" then
            if to == "EQUIP" then return result("interrupt", .04) end
            if ctx.incoming_finite then return result("queue", .04) end
        end
        return result("reject")
    end

    function machine.sample(kind, ammo, capacity, length, fps)
        if capacity <= 0 or length <= 0 then return 0 end
        if kind == "per_round" then
            if fps <= 0 or ammo > 0 then return 0 end
            return math.max(0, length - 1 / fps)
        end
        return length * math.min(capacity, math.max(0, capacity - ammo)) / capacity
    end
    return machine
end
return M
