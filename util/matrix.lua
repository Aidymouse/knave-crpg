return {
    invert_matrix = function(a, b, c, d)
        local det = (1 / (a * d - b * c))

        return {
            a = d * det,
            b = -b * det,
            c = -c * det,
            d = a * det,
        }
    end
}
