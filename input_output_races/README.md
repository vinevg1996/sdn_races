Input / Output Races
===================

These races can occur when there exists a state of a corresponding EIOA where both inputs and outputs are allowed which have a parameter in common, i.e., at a given state the decision of accepting an input or producing an output is made nondeterministically. The EIOA modeling the Controller behavior can be found in “controller\_efsm.pdf” file. At state <nobr>s_2</nobr>, the <nobr>(FlowExpire, flow\_id)</nobr> signal can be applied and the <nobr>(DelFlow, flow\_id)</nobr> signal can be produced.

Promela code
------------

The Spin model checker is used for verifying the LTL formula prohibiting races between <nobr>i</nobr> and <nobr>o</nobr>. The corresponding Promela code is available at "controller_under_test.pml" file. The LTL formula <nobr>f_1 = G(((mess = DelFlow) && (flow\_id = 0)) -> (table[0] = true))</nobr> was violated and the counterexample is available at "picture_counterexample.pdf" file.

Perl script
-----------

Perl script executing the counterexample can be found in "openflow_races" file. The script of interest was executed 10 times and at the 4-th iteration an unexpected behavior arose. In particular, a rule deleted (via a timeout) produced a <nobr>FlowExpire</nobr> message from the switch to the controller, however, the controller at a later time instance produced a <nobr>FlowDelete</nobr> message for the same rule ID. The latter means, that the flow table of the controller can be dis-synchronized, i.e., the controller’s knowledge of the network state is not always relevant and up-to-date. And we can’t predict which action removed the rule: <nobr>FlowExpire</nobr> or <nobr>DelFlow</nobr>.

In the files "logs/test_1.txt", "logs/test_2.txt" and "logs/test_3.txt" <nobr>FLOW_REMOVED</nobr> signal was sent 5 times and in "logs/test_4.txt", <nobr>FLOW_REMOVED</nobr> signal was sent 3 times. This means that to delete a rule with number 5000 in first 3 cases the controller sends <nobr>FLOW_REMOVED</nobr> signal and in the fourth case the switch sent <nobr>FLOW_EXPIRE</nobr> earlier.

In the files "extended_logs/test_1.txt", "extended_logs/test_2.txt", "extended_logs/test_3.txt" and "extended_logs/test_4.txt" are located logs of script execution with uninteresting for us messages.
