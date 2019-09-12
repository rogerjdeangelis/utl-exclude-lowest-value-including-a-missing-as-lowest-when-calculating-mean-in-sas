SAS-L: Exclude lowest value including a missing as lowest when calculating mean in sas                                        
                                                                                                                              
I consider missing as a valid lowest value and keep second lowests.                                                           
                                                                                                                              
Not as simple as you think because of edge conditions                                                                         
Hope I regret this statement.                                                                                                 
                                                                                                                              
Excludes the lowest value when calculating mean                                                                               
                                                                                                                              
Edge conditions                                                                                                               
                                                                                                                              
 1. Multiple lowest                                                                                                           
 2. All lowest                                                                                                                
 3. Missings  (can be the lowest)                                                                                             
                                                                                                                              
                                                                                                                              
github                                                                                                                        
https://tinyurl.com/y3nmaxlm                                                                                                  
https://github.com/rogerjdeangelis/utl-exclude-lowest-value-including-a-missing-as-lowest-when-calculating-mean-in-sas        
                                                                                                                              
SAS Forum                                                                                                                     
https://tinyurl.com/y4ykhf39                                                                                                  
https://communities.sas.com/t5/SAS-Programming/excludes-the-lowest-value-when-calculating-mean-in-SAS/m-p/586609              
                                                                                                                              
*_                   _                                                                                                        
(_)_ __  _ __  _   _| |_                                                                                                      
| | '_ \| '_ \| | | | __|                                                                                                     
| | | | | |_) | |_| | |_                                                                                                      
|_|_| |_| .__/ \__,_|\__|                                                                                                     
        |_|                                                                                                                   
;                                                                                                                             
data have;                                                                                                                    
                                                                                                                              
  do nums=1 to 8;                                                                                                             
     num=int(10*uniform(12533));                                                                                              
     if mod(nums,3)=0 then num=.;                                                                                             
     output;                                                                                                                  
  end;                                                                                                                        
                                                                                                                              
run;quit;                                                                                                                     
                                                                                                                              
WORK.HAVE total obs=8                                                                                                         
                | RULES                                                                                                       
  NUMS    NUM   | If all non-missing then exclude 0                                                                           
                |                                                                                                             
    1      1    |                                                                                                             
    2      1    |                                                                                                             
    3      .    |                                                                                                             
    4      0    |                                                                                                             
    5      4    |                                                                                                             
    6      .    |                                                                                                             
    7      1    |                                                                                                             
    8      6    | (1+1+0+4+1+6)/6 = 2.1666666667                                                                              
                                                                                                                              
*            _               _                                                                                                
  ___  _   _| |_ _ __  _   _| |_                                                                                              
 / _ \| | | | __| '_ \| | | | __|                                                                                             
| (_) | |_| | |_| |_) | |_| | |_                                                                                              
 \___/ \__,_|\__| .__/ \__,_|\__|                                                                                             
                |_|                                                                                                           
;                                                                                                                             
                                                                                                                              
                                                                                                                              
WORK.WANT total obs=1                                                                                                         
                                                                                                                              
  MEAN_NUM                                                                                                                    
                                                                                                                              
   2.16667                                                                                                                    
                                                                                                                              
*          _       _   _                                                                                                      
 ___  ___ | |_   _| |_(_) ___  _ __                                                                                           
/ __|/ _ \| | | | | __| |/ _ \| '_ \                                                                                          
\__ \ (_) | | |_| | |_| | (_) | | | |                                                                                         
|___/\___/|_|\__,_|\__|_|\___/|_| |_|                                                                                         
                                                                                                                              
;                                                                                                                             
                                                                                                                              
* note >< unlike min includes missing as a minimum;                                                                           
%symdel smallest / nowarn;                                                                                                    
                                                                                                                              
proc means  data=have(where=( num ne %let rc=%ysyfunc(dosubl('                                                                
                                                                                                                              
 data _null_;                                                                                                                 
    retain smallest %sysfunc(constant(big));                                                                                  
    set have end=dne;                                                                                                         
    smallest=smallest >< num;                                                                                                 
    if dne then call symputx("smallest",smallest);                                                                            
 run;quit;                                                                                                                    
                                                                                                                              
 '));                                                                                                                         
                                                                                                                              
 symgetn("smallest") ));                                                                                                      
                                                                                                                              
var num;                                                                                                                      
output out=want(drop=_:) mean=mean_num;                                                                                       
                                                                                                                              
run;quit;                                                                                                                     
                                                                                                                              
                                                                                                                              
                                                                                                                              
