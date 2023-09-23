local json = require("integrator.json")
describe("decode", function()
    describe("object", function()
        it("empty", function()
            assert.are.same({}, json.decode("{}"))
        end)
        it("number", function()
            local obj = json.decode([[{"id": 12}]])
            assert.are.same({ id = 12 }, obj)
            assert.are.same(12, obj:get("id"))
        end)

        it("string", function()
            local obj = json.decode([[{"name": "myname"}]])
            assert.are.same({ name = "myname" }, obj)
            assert.are.same("myname", obj:get("name"))
        end)
        it("magic key", function()
            local obj = json.decode([[{"person": {"name": "myname"} }]])
            assert.are.same({ person = { name = "myname" } }, obj)
            assert.are.same("myname", obj:get("person.name"))
        end)
    end)
    it("array", function()
        it("empty", function()
            assert.are.same({}, json.decode("[]"))
        end)
        it("number", function()
            local obj = json.decode("[11, 22, 33]")
            assert.are.same({ 11, 22, 33 }, obj)
        end)
    end)
end)

describe("flatten", function()
    it("simple level", function()
        assert.are.same({}, json.flatten({}))
        assert.are.same({ id = 12 }, json.flatten({ id = 12 }))
        assert.are.same({ name = "myname" }, json.flatten({ name = "myname" }))

        assert.are.same({ name = { id = 12 } }, json.flatten({ ["name.id"] = 12 }))
        assert.are.same({ first = { second = { third = 12 } } }, json.flatten({ ["first.second.third"] = 12 }))
    end)
    it("array object mixture", function()
        assert.are.same({ name = { arr = { 1, 2 } } }, json.flatten({ ["name.arr"] = { 1, 2 } }))
        assert.are.same({ { first = { second = 12 } } }, json.flatten({ { ["first.second"] = 12 } }))
    end)
end)
