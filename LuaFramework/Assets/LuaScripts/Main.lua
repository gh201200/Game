import "UnityEngine"

require "common.common"


local mt = {
    name = "god",
    age = 25,
    sex = true,
    display = function(str)
        print(str)
    end,
    language = {
        "chinese",
        "english",
        "japanese",
        other = {
            key1 = "value1",
            key2 = "value2",
            key3 = "value3",
            other2 = {
                key1 = "value1",
                key2 = "value2",
                key3 = "value3",
                other3 = {
                    key1 = "value1",
                    key2 = "value2",
                    key3 = "value3"
                }
            }
        }
    }
}

print(mt)