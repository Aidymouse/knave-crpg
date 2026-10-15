local function print_table(table)
    for _, v in pairs(table) do
        print(v)
    end
end

return {
    print_table = print_table
}