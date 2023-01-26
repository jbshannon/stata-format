
-- Reformat all heading text 
-- function Header(el)
--   el.content = pandoc.Emph(el.content)
--   return el
-- end

-- Remove redundant line breaks
function trim(s)
  s = string.gsub(s, "\n+", "\n")
  s = string.gsub(s, "^\n", "")
  return s
end

function trim_insert(a, b)
  if b.content ~= nil then 
    b.content[1].text = trim(b.content[1].text)
  end
  table.insert(a, b)
end

-- Check some stuff about code blocks
function Div(el)
  if el.attr and el.attr.classes[1] == "cell" then
    N = {}
    current = {}
    for i, item in ipairs(el.content) do
      if item.attr.classes[2] ~= "cell-output-stdout" then -- cell code
        table.insert(N, item)
      else -- cell output
        if current.attr == nil then -- if there is no selected cell
          current = item -- select the next cell
        else
          if item.attr.classes[2] == current.attr.classes[2] then -- if the next cell has the same output type as the selected cell
            current.content[1].text = current.content[1].text .. '\n' .. item.content[1].text -- add the output text from the next cell to the selected cell
          else -- if the next output is a different type, append the cell and move on
            trim_insert(N, current)
            current = {}
          end
        end
      end
    end
    trim_insert(N, current)
    -- quarto.log.output(N)
    return N
  end
end
