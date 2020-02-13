Intra-channel Races
===================

These races can occur between various messages in EIOA composition. For us the most interesting part of EIOA composition is the Channel1. The EIOA modeling the behavior of Channel1 can be found in “channel1.pdf” file.

Promela code
------------

The Spin model checker is used for verifying the LTL formula prohibiting intra-channel races. Promela code for this description of EIOA composition is available at “channel1_under_test.pml” file. The LTL formula 
<nobr>f = G( ((app_table[4] = 0) -> (app_table[3] = 0)) && ((app_table[3] = 0) -> (app_table[2] = 0)) &&</nobr>
<nobr>((app_table[2] = 0) -> (app_table[1] = 0)) && ((app_table[1] = 0) -> (app_table[0] = 0)) )</nobr> 
was violated and the corresponding counterexample can be found in “picture_counterexample.pdf” file.

Perl script
-----------

Fig. “demo_at_the_begining.png” presents the rules as initially installed while Fig. “demo_at_the_end.png” presents the rules at the end. Note that the rules <nobr>5003</nobr> and <nobr>5004</nobr> expired, however, the rule <nobr>5002</nobr> is still present, although the value of the timeout in the rule <nobr>5002</nobr> is set to 7 seconds while the timeout of the rules <nobr>5003</nobr> and <nobr>5004</nobr> are set to 8 and 9 seconds, correspondingly.
