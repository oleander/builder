# [![Builder](https://github.com/oleander/builder/actions/workflows/main.yml/badge.svg)](https://github.com/oleander/builder/actions/workflows/main.yml)

## Example

``` ruby
require "h_builder"

# Local values
name = "John"
age = 50

hash = HBuilder.define(binding) do
  person do
    name name
    age age
    cars do
      array do
        name "BMW"
        name "Volvo"
      end
    end
  end
end

pp hash
```
