# Races in SDN

These project is devoted to race detection in SDN. You can find the
description and experimental results of the three types of races:
\"input_input_races\", \"input_output_races\" and
\"output_output_races\".

#### Input/Output races.

These races can occur when there exists a state of a corresponding EIOA
where both an input and an output are specified, i.e., at a given state
the decision of accepting an input or producing an output is made
nondeterministically by a SUT. Informally, as we do not know the
implementation timeouts, we say that the SUT can be race-sensitive to
Input/Output races if in the specification, there exists a trace where
the output $o$ appears before the input $i$ was applied.

#### Input/Input races.

Having discussed the input/output races at a given state, we now turn to
the detection of other types of races. In particular, this subsection is
devoted to detecting races in the composition of the controller and
switch where in a given state either two (or more) inputs (or two
outputs) compete.

#### Output/Output Races.

These races can occur between various messages in EIOA composition. The
reason of these races is the order of the rules or requests submitted
into an internal channel by a given component is not necessarily
preserved. When the same sequence of external inputs is applied asking
for analyzing/adding/deleting rules in the switch the order of these
requests can be changed. Correspondingly, the order of the replies to
the applications is changed and thus, the same external input sequence
in C&S can result in different configurations. The change of the order
of the requests can occur as there are no regulations how long a message
can stay in the channel between the controller and switch; this duration
for each message is nondeterministically determined depending on the
current configuration and SDN framework features.

Promela description can be founded at file \"cont_switch.pml\". The
experimental data is collected by the script \"collect_pf_data.py\".
Perl scripts for executing the counterexamples for each types of races
can be found in the corresponding directories.

