select * from products

select substr(products.productcode,2,2) as code_part ,
       substr(products.productscale,3) as scaled_end
from products