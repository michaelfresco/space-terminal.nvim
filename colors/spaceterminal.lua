for k in pairs(package.loaded) do
    if k:match(".*spaceterminal.*") then package.loaded[k] = nil end
end

require('spaceterminal').setup()
require('spaceterminal').colorscheme()
