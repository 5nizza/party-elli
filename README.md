Party
=====

Parameterized Synthesis of Token Rings

## Requirements ##
Ubuntu 12.04     
Z3 (tested with version 4.1)      
ltl3ba (tested with version 1.0.2)       
python3 (tested with version 3.2)       

## To configure ##
add file named "config" to the root directory       
the file should contain two lines:      
z3=path/to/z3/executable       
ltl3ba=path/to/ltl3ba/executable        

## To run ##
python3 p_bosy.py -- to run parameterized synthesis tool         
python3 bosy.py -- to run monolithic synthesis tool         

## To test ##
nosetests ./

## Questions ##
, suggestions and bug reports submit to github      
or directly to Ayrat: ayrat.khalimov(tugraz.at)

## Authors ##
Ayrat Khalimov,Swen Jacobs,Roderick Bloem, TU Graz.

## License ## 
free for any use with references to the original authors
