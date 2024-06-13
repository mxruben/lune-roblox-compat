local modules = {
    ["net"] = require("tests/net.test")
}

for modName, tests in modules do
    print(`Running tests for module '{modName}'`)
    for _, entry in tests do
        print(`\tRunning test '{entry.name}'`)
        entry.test()
    end
end

print("All tests passed!")
