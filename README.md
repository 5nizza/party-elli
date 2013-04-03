Party
=====

Parameterized Synthesis of Token Rings

## Requirements ##
Ubuntu 12.04 (likely to work with others)            
Z3 (tested with version 4.1 and 4.3.1)      
ltl3ba (tested with version 1.0.2)       
python3 (tested with version 3.2)       
pygraph py package: download from https://code.google.com/p/python-graph/ 
and install using python3

## To configure ##
modify file config.py in src directory     
with absolute paths to executables of z3 and ltl3ba       

(if you plan to develop smth then you might want 
to ignore future changes to config.py, to do so run            
git update-index --assume-unchanged src/config.py)          
(.gitignore is not enough)           

## To run ##
python3 p_bosy.py -- to run parameterized synthesis tool         
python3 bosy.py -- to run monolithic synthesis tool         

## To test ##
nosetests ./        
Requires nosetests package.      
Also directory ./tests contains functional tests          
test_parameterized.py       
test_monolithic.py       

## Questions ##
, suggestions and bug reports submit to github      
or directly to Ayrat: ayrat.khalimov(gmail)

## Authors ##
Ayrat Khalimov,Swen Jacobs,Roderick Bloem, TU Graz.

## License ## 
free for any use with references to the original authors
