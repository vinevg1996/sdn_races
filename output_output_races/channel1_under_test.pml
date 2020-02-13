mtype = {
    PostFlow, FlowExpire
}

int rule_numbers = 5;

//App
mtype mess_app;
int curr_add_rule_in_app_table = 0;
int app_flow_id;
bool app_table[rule_numbers];

// Cont
int cont_flow_id;

// Channel1
bool buffer[rule_numbers];
int curr_size_buffer = 0;
int channel1_flow_id;

// Channel2
int channel2_flow_id;

// Switch
mtype mess_switch;
bool switch_table[rule_numbers];
int curr_size_switch_table = 0;
int switch_flow_id;
int id = 0;

////////////////
proctype App(chan ContApp, AppCont) {
    app_table[4] = 1;
    app_table[3] = 1;
    app_table[2] = 1;
    app_table[1] = 1;
    app_table[0] = 1;

    S0: if
        ::  (curr_add_rule_in_app_table < rule_numbers) ->
            atomic {
                if
                ::  (curr_add_rule_in_app_table == 0) ->
                        AppCont!PostFlow(0);
                ::  (curr_add_rule_in_app_table == 1) ->
                        AppCont!PostFlow(1);
                ::  (curr_add_rule_in_app_table == 2) ->
                        AppCont!PostFlow(2);
                ::  (curr_add_rule_in_app_table == 3) ->
                        AppCont!PostFlow(3);
                ::  (curr_add_rule_in_app_table == 4) ->
                        AppCont!PostFlow(4);
                fi;
                mess_app = PostFlow;
                //app_table[curr_add_rule_in_app_table] = 1
                curr_add_rule_in_app_table = curr_add_rule_in_app_table + 1
                goto S0
            }
        ::  atomic {
                ContApp?FlowExpire(app_flow_id);
                mess_app = FlowExpire;
                app_table[app_flow_id] = 0;
                goto S0;
            }
        fi;
}

proctype Controller(chan AppCont, ContApp, Ch2Cont, ContCh1) {
    S0: if
        ::  atomic {
                AppCont?PostFlow(cont_flow_id);
                ContCh1!PostFlow(cont_flow_id);
                goto S0;
            }
        ::  atomic {
                Ch2Cont?FlowExpire(cont_flow_id);
                ContApp!FlowExpire(cont_flow_id);
                goto S0;
            }
        fi;
}

proctype Channel1(chan ContCh1, Ch1Switch) {
    S0: atomic {
            ContCh1?PostFlow(channel1_flow_id);
            buffer[channel1_flow_id] = true;
            curr_size_buffer = curr_size_buffer + 1;
            goto S1;
        }
    S1: if
        ::  atomic {
                ContCh1?PostFlow(channel1_flow_id);
                buffer[channel1_flow_id] = true;
                curr_size_buffer = curr_size_buffer + 1;
                goto S1;
            }
        ::  (curr_size_buffer > 1) ->
            if
            ::  (buffer[0] == true) ->
                atomic {
                    Ch1Switch!PostFlow(0);
                    buffer[0] = false;
                    curr_size_buffer = curr_size_buffer - 1;
                    goto S1;
                }
            ::  (buffer[1] == true) ->
                atomic {
                    Ch1Switch!PostFlow(1);
                    buffer[1] = false;
                    curr_size_buffer = curr_size_buffer - 1;
                    goto S1;
                }
            ::  (buffer[2] == true) ->
                atomic {
                    Ch1Switch!PostFlow(2);
                    buffer[2] = false;
                    curr_size_buffer = curr_size_buffer - 1;
                    goto S1;
                }
            ::  (buffer[3] == true) ->
                atomic {
                    Ch1Switch!PostFlow(3);
                    buffer[3] = false;
                    curr_size_buffer = curr_size_buffer - 1;
                    goto S1;
                }
            ::  (buffer[4] == true) ->
                atomic {
                    Ch1Switch!PostFlow(4);
                    buffer[4] = false;
                    curr_size_buffer = curr_size_buffer - 1;
                    goto S1;
                }
            fi
        ::  (curr_size_buffer == 1) ->
            if
            ::  (buffer[0] == true) ->
                atomic {
                    Ch1Switch!PostFlow(0);
                    buffer[0] = false;
                    curr_size_buffer = curr_size_buffer - 1;
                    goto S0;
                }
            ::  (buffer[1] == true) ->
                atomic {
                    Ch1Switch!PostFlow(1);
                    buffer[1] = false;
                    curr_size_buffer = curr_size_buffer - 1;
                    goto S0;
                }
            ::  (buffer[2] == true) ->
                atomic {
                    Ch1Switch!PostFlow(2);
                    buffer[2] = false;
                    curr_size_buffer = curr_size_buffer - 1;
                    goto S0;
                }
            ::  (buffer[3] == true) ->
                atomic {
                    Ch1Switch!PostFlow(3);
                    buffer[3] = false;
                    curr_size_buffer = curr_size_buffer - 1;
                    goto S0;
                }
            ::  (buffer[4] == true) ->
                atomic {
                    Ch1Switch!PostFlow(4);
                    buffer[4] = false;
                    curr_size_buffer = curr_size_buffer - 1;
                    goto S0;
                }
            fi
        fi;
}

proctype Channel2(chan SwitchCh2, Ch2Cont) {
    S0: if
        ::  atomic {
                SwitchCh2?FlowExpire(channel2_flow_id);
                Ch2Cont!FlowExpire(channel2_flow_id);
                goto S0;
            }
        fi;
}

proctype Switch(chan Ch1Switch, SwitchCh2) {
    S0: if
        ::  atomic {
                Ch1Switch?PostFlow(switch_flow_id);
                mess_switch = PostFlow;
                switch_table[switch_flow_id] = true;
                goto S0;
            }
        ::  (switch_table[id] == true) ->
            atomic {
                if
                ::  (id == 0) ->
                        SwitchCh2!FlowExpire(0);
                ::  (id == 1) ->
                        SwitchCh2!FlowExpire(1);
                ::  (id == 2) ->
                        SwitchCh2!FlowExpire(2);
                ::  (id == 3) ->
                        SwitchCh2!FlowExpire(3);
                ::  (id == 4) ->
                        SwitchCh2!FlowExpire(4);
                fi;
                mess_switch = FlowExpire;
                switch_table[id] = false;
                id = (id + 1) % rule_numbers;
                goto S0;
            }
        ::  (switch_table[id] == false) ->
            atomic {
                id = (id + 1) % rule_numbers;
                goto S0;
            }
        fi;
}

init {
    chan AppCont = [0] of { mtype, int };
    chan ContApp = [0] of { mtype, int };
    chan ContCh1 = [0] of { mtype, int };
    chan Ch1Switch = [0] of { mtype, int };
    chan SwitchCh2 = [0] of { mtype, int };
    chan Ch2Cont = [0] of { mtype, int };
    
    /*
    chan AppCont = [1] of { mtype, int };
    chan ContApp = [1] of { mtype, int };
    chan ContCh1 = [1] of { mtype, int };
    chan Ch1Switch = [1] of { mtype, int };
    chan SwitchCh2 = [1] of { mtype, int };
    chan Ch2Cont = [1] of { mtype, int };
    */
    atomic {
        run App(ContApp, AppCont);
        run Controller(AppCont, ContApp, Ch2Cont, ContCh1);
        run Channel1(ContCh1, Ch1Switch);
        run Channel2(SwitchCh2, Ch2Cont);
        run Switch(Ch1Switch, SwitchCh2);
    }
}

ltl f{[](
    ((app_table[4] == 0) -> (app_table[3] == 0)) &&
    ((app_table[3] == 0) -> (app_table[2] == 0)) &&
    ((app_table[2] == 0) -> (app_table[1] == 0)) &&
    ((app_table[1] == 0) -> (app_table[0] == 0))
    )}
