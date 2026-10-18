local List = require "List"

local L = List:New()

L:Push(1)
L:Push(2)
L:Push(3)

assert(L:Has(3) == true, "Failed - Has check")
assert(L:Has(5) == false, "Failed - Doesn't Has check")

assert(L:At(-1) == 3)

assert(L:Length() == 3, "Failed - Length Check")

assert(L:Pop() == 3, "Failed - Pop Check")
assert(L:Length() == 2, "Failed - Pop Length Check")


print("Passed :)")
