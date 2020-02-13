mtype = {
    PostFlow, GetFlow, DelFlow,
    FlowExpire, ReplyFlow
}

mtype mess;
int flow_id;

// App
bool app_table[3];
bool deadlock = false;
// Switch
bool switch_table[3];
mtype mess_switch;
int switch_id;
////////////////

proctype Application(chan ContApp, AppCont) {
    mtype mess_app;
    int index_flow_app;
    S0: if
        ::  atomic {
                ContApp?ReplyFlow(index_flow_app);
                goto S0;
            }
        ::  atomic {
                ContApp?FlowExpire(index_flow_app);
                goto S0;
            }
        ::  atomic {
                AppCont!PostFlow(0);
                goto S0;
            }
        ::  atomic {
                AppCont!PostFlow(1);
                goto S0;
            }
        ::  atomic {
                AppCont!PostFlow(2);
                goto S0;
            }
        ::  atomic {
                AppCont!GetFlow(0);
                goto S0;
            }
        ::  atomic {
                AppCont!GetFlow(1);
                goto S0;
            }
        ::  atomic {
                AppCont!GetFlow(2);
                goto S0;
            }
        ::  atomic {
                AppCont!DelFlow(0);
                goto S0;
            }
        ::  atomic {
                AppCont!DelFlow(1);
                goto S0;
            }
        ::  atomic {
                AppCont!DelFlow(2);
                goto S0;
            }
        ::  timeout -> 
                deadlock = true;
        fi;
}

proctype Controller(chan AppCont, ContApp, Ch2Cont, ContCh1) {
    mtype mess_app_cont;
    int id_flow_app, id_flow_cont;
    S0:
        if
        ::  AppCont?(mess_app_cont, id_flow_app);
            goto S0;
        ::  (app_table[0] == false) ->
            atomic {
                do
                ::  AppCont?(mess_app_cont, id_flow_app);
                    goto S0;
                ::  ContCh1!PostFlow(0);
                    app_table[0] = true;
                    mess = PostFlow;
                    flow_id = 0;
                    goto S0;
                ::  Ch2Cont?FlowExpire(id_flow_cont);
                    ContApp!FlowExpire(id_flow_cont);
                    app_table[id_flow_cont] = false;
                    mess = FlowExpire;
                    flow_id = id_flow_cont;
                    goto S0;
                ::  Ch2Cont?ReplyFlow(id_flow_cont);
                    ContApp!ReplyFlow(id_flow_cont);
                    mess = ReplyFlow;
                    flow_id = id_flow_cont;
                    goto S2;
                od;
            }
        ::  (app_table[1] == false) ->
            atomic {
                do
                ::  AppCont?(mess_app_cont, id_flow_app);
                    goto S0;
                ::  ContCh1!PostFlow(1);
                    app_table[1] = true;
                    mess = PostFlow;
                    flow_id = 1;
                    goto S0;
                ::  Ch2Cont?FlowExpire(id_flow_cont);
                    ContApp!FlowExpire(id_flow_cont);
                    app_table[id_flow_cont] = false;
                    mess = FlowExpire;
                    flow_id = id_flow_cont;
                    goto S0;
                ::  Ch2Cont?ReplyFlow(id_flow_cont);
                    ContApp!ReplyFlow(id_flow_cont);
                    mess = ReplyFlow;
                    flow_id = id_flow_cont;
                    goto S2;
                od;
            }
        ::  (app_table[2] == false) ->
            atomic {
                do
                ::  AppCont?(mess_app_cont, id_flow_app);
                    goto S0;
                ::  ContCh1!PostFlow(2);
                    app_table[2] = true;
                    mess = PostFlow;
                    flow_id = 2;
                    goto S0;
                ::  Ch2Cont?FlowExpire(id_flow_cont);
                    ContApp!FlowExpire(id_flow_cont);
                    app_table[id_flow_cont] = false;
                    mess = FlowExpire;
                    flow_id = id_flow_cont;
                    goto S0;
                ::  Ch2Cont?ReplyFlow(id_flow_cont);
                    ContApp!ReplyFlow(id_flow_cont);
                    mess = ReplyFlow;
                    flow_id = id_flow_cont;
                    goto S2;
                od;
            }
        ::  (app_table[0] == true) ->
            atomic {
                do
                ::  AppCont?(mess_app_cont, id_flow_app);
                    goto S0;
                ::  ContCh1!GetFlow(0);
                    mess = GetFlow;
                    flow_id = 0;
                    goto S1;
                ::  Ch2Cont?FlowExpire(id_flow_cont);
                    ContApp!FlowExpire(id_flow_cont);
                    app_table[id_flow_cont] = false;
                    mess = FlowExpire;
                    flow_id = id_flow_cont;
                    goto S0;
                ::  Ch2Cont?ReplyFlow(id_flow_cont);
                    ContApp!ReplyFlow(id_flow_cont);
                    mess = ReplyFlow;
                    flow_id = id_flow_cont;
                    goto S2;
                od;
            }
        ::  (app_table[1] == true) ->
            atomic {
                do
                ::  AppCont?(mess_app_cont, id_flow_app);
                    goto S0;
                ::  ContCh1!GetFlow(1);
                    mess = GetFlow;
                    flow_id = 1;
                    goto S1;
                ::  Ch2Cont?FlowExpire(id_flow_cont);
                    ContApp!FlowExpire(id_flow_cont);
                    app_table[id_flow_cont] = false;
                    mess = FlowExpire;
                    flow_id = id_flow_cont;
                    goto S0;
                ::  Ch2Cont?ReplyFlow(id_flow_cont);
                    ContApp!ReplyFlow(id_flow_cont);
                    mess = ReplyFlow;
                    flow_id = id_flow_cont;
                    goto S2;
                od;
            }
        ::  (app_table[2] == true) ->
            atomic {
                do
                ::  AppCont?(mess_app_cont, id_flow_app);
                    goto S0;
                ::  ContCh1!GetFlow(2);
                    mess = GetFlow;
                    flow_id = 2;
                    goto S1;
                ::  Ch2Cont?FlowExpire(id_flow_cont);
                    ContApp!FlowExpire(id_flow_cont);
                    app_table[id_flow_cont] = false;
                    mess = FlowExpire;
                    flow_id = id_flow_cont;
                    goto S0;
                ::  Ch2Cont?ReplyFlow(id_flow_cont);
                    ContApp!ReplyFlow(id_flow_cont);
                    mess = ReplyFlow;
                    flow_id = id_flow_cont;
                    goto S2;
                od;
            }
        fi;
    //////////////
    S1: if
        ::  AppCont?(mess_app_cont, id_flow_app);
            goto S1;
        ::  (app_table[0] == false) ->
            atomic {
                do
                ::  AppCont?(mess_app_cont, id_flow_app);
                    goto S1;
                ::  ContCh1!PostFlow(0);
                    app_table[0] = true;
                    mess = PostFlow;
                    flow_id = 0;
                    goto S1;
                ::  Ch2Cont?FlowExpire(id_flow_cont);
                    ContApp!FlowExpire(id_flow_cont);
                    app_table[id_flow_cont] = false;
                    mess = FlowExpire;
                    flow_id = id_flow_cont;
                    goto S1;
                ::  Ch2Cont?ReplyFlow(id_flow_cont);
                    ContApp!ReplyFlow(id_flow_cont);
                    mess = ReplyFlow;
                    flow_id = id_flow_cont;
                    goto S2;
                od;
            }
        ::  (app_table[1] == false) ->
            atomic {
                do
                ::  AppCont?(mess_app_cont, id_flow_app);
                    goto S1;
                ::  ContCh1!PostFlow(1);
                    app_table[1] = true;
                    mess = PostFlow;
                    flow_id = 1;
                    goto S1;
                ::  Ch2Cont?FlowExpire(id_flow_cont);
                    ContApp!FlowExpire(id_flow_cont);
                    app_table[id_flow_cont] = false;
                    mess = FlowExpire;
                    flow_id = id_flow_cont;
                    goto S1;
                ::  Ch2Cont?ReplyFlow(id_flow_cont);
                    ContApp!ReplyFlow(id_flow_cont);
                    mess = ReplyFlow;
                    flow_id = id_flow_cont;
                    goto S2;
                od;
            }
        ::  (app_table[2] == false) ->
            atomic {
                do
                ::  AppCont?(mess_app_cont, id_flow_app);
                    goto S1;
                ::  ContCh1!PostFlow(2);
                    app_table[2] = true;
                    mess = PostFlow;
                    flow_id = 2;
                    goto S1;
                ::  Ch2Cont?FlowExpire(id_flow_cont);
                    ContApp!FlowExpire(id_flow_cont);
                    app_table[id_flow_cont] = false;
                    mess = FlowExpire;
                    flow_id = id_flow_cont;
                    goto S1;
                ::  Ch2Cont?ReplyFlow(id_flow_cont);
                    ContApp!ReplyFlow(id_flow_cont);
                    mess = ReplyFlow;
                    flow_id = id_flow_cont;
                    goto S2;
                od;
            }
        ::  (app_table[0] == true) ->
            atomic {
                do
                ::  AppCont?(mess_app_cont, id_flow_app);
                    goto S1;
                ::  Ch2Cont?FlowExpire(id_flow_cont);
                    ContApp!FlowExpire(id_flow_cont);
                    app_table[id_flow_cont] = false;
                    mess = FlowExpire;
                    flow_id = id_flow_cont;
                    goto S1;
                ::  Ch2Cont?ReplyFlow(id_flow_cont);
                    ContApp!ReplyFlow(id_flow_cont);
                    mess = ReplyFlow;
                    flow_id = id_flow_cont;
                    goto S2;
                od;
            }
        ::  (app_table[1] == true) ->
            atomic {
                do
                ::  AppCont?(mess_app_cont, id_flow_app);
                    goto S1;
                ::  Ch2Cont?FlowExpire(id_flow_cont);
                    ContApp!FlowExpire(id_flow_cont);
                    app_table[id_flow_cont] = false;
                    mess = FlowExpire;
                    flow_id = id_flow_cont;
                    goto S1;
                ::  Ch2Cont?ReplyFlow(id_flow_cont);
                    ContApp!ReplyFlow(id_flow_cont);
                    mess = ReplyFlow;
                    flow_id = id_flow_cont;
                    goto S2;
                od;
            }
        ::  (app_table[2] == true) ->
            atomic {
                do
                ::  AppCont?(mess_app_cont, id_flow_app);
                    goto S1;
                ::  Ch2Cont?FlowExpire(id_flow_cont);
                    ContApp!FlowExpire(id_flow_cont);
                    app_table[id_flow_cont] = false;
                    mess = FlowExpire;
                    flow_id = id_flow_cont;
                    goto S1;
                ::  Ch2Cont?ReplyFlow(id_flow_cont);
                    ContApp!ReplyFlow(id_flow_cont);
                    mess = ReplyFlow;
                    flow_id = id_flow_cont;
                    goto S2;
                od;
            }
        ::  timeout -> 
                deadlock = true;
        fi;
    ////////////////
    S2: if
        ::  AppCont?(mess_app_cont, id_flow_app);
            goto S2;
        ::  ContCh1!DelFlow(id_flow_cont);
            app_table[id_flow_cont] = false;
            mess = DelFlow;
            flow_id = id_flow_cont;
            goto S0;
        ::  (app_table[0] == false) ->
            atomic {
                do
                ::  AppCont?(mess_app_cont, id_flow_app);
                    goto S2;
                ::  ContCh1!PostFlow(0);
                    app_table[0] = true;
                    mess = PostFlow;
                    flow_id = 0;
                    goto S2;
                ::  Ch2Cont?FlowExpire(id_flow_cont);
                    ContApp!FlowExpire(id_flow_cont);
                    app_table[id_flow_cont] = false;
                    mess = FlowExpire;
                    flow_id = id_flow_cont;
                    goto S2;
                ::  Ch2Cont?ReplyFlow(id_flow_cont);
                    ContApp!ReplyFlow(id_flow_cont);
                    ContCh1!DelFlow(id_flow_cont);
                    app_table[id_flow_cont] = false;
                    mess = DelFlow;
                    flow_id = id_flow_cont;
                    goto S0;
                od;
            }
        ::  (app_table[1] == false) ->
            atomic {
                do
                ::  AppCont?(mess_app_cont, id_flow_app);
                    goto S2;
                ::  ContCh1!PostFlow(1);
                    app_table[1] = true;
                    mess = PostFlow;
                    flow_id = 1;
                    goto S2;
                ::  Ch2Cont?FlowExpire(id_flow_cont);
                    ContApp!FlowExpire(id_flow_cont);
                    app_table[id_flow_cont] = false;
                    mess = FlowExpire;
                    flow_id = id_flow_cont;
                    goto S2;
                ::  Ch2Cont?ReplyFlow(id_flow_cont);
                    ContApp!ReplyFlow(id_flow_cont);
                    ContCh1!DelFlow(id_flow_cont);
                    app_table[id_flow_cont] = false;
                    mess = DelFlow;
                    flow_id = id_flow_cont;
                    goto S0;
                od;
            }
        ::  (app_table[2] == false) ->
            atomic {
                do
                ::  AppCont?(mess_app_cont, id_flow_app);
                    goto S2;
                ::  ContCh1!PostFlow(2);
                    app_table[2] = true;
                    mess = PostFlow;
                    flow_id = 2;
                    goto S2;
                ::  Ch2Cont?FlowExpire(id_flow_cont);
                    ContApp!FlowExpire(id_flow_cont);
                    app_table[id_flow_cont] = false;
                    mess = FlowExpire;
                    flow_id = id_flow_cont;
                    goto S2;
                ::  Ch2Cont?ReplyFlow(id_flow_cont);
                    ContApp!ReplyFlow(id_flow_cont);
                    ContCh1!DelFlow(id_flow_cont);
                    app_table[id_flow_cont] = false;
                    mess = DelFlow;
                    flow_id = id_flow_cont;
                    goto S0;
                od;
            }
        ::  (app_table[0] == true) ->
            atomic {
                do
                ::  AppCont?(mess_app_cont, id_flow_app);
                    goto S2;
                ::  ContCh1!GetFlow(0);
                    mess = GetFlow;
                    flow_id = 0;
                    goto S1;
                ::  Ch2Cont?FlowExpire(id_flow_cont);
                    ContApp!FlowExpire(id_flow_cont);
                    app_table[id_flow_cont] = false;
                    mess = FlowExpire;
                    flow_id = id_flow_cont;
                    goto S2;
                ::  Ch2Cont?ReplyFlow(id_flow_cont);
                    ContApp!ReplyFlow(id_flow_cont);
                    ContCh1!DelFlow(id_flow_cont);
                    app_table[id_flow_cont] = false;
                    mess = DelFlow;
                    flow_id = id_flow_cont;
                    goto S0;
                od;
            }
        ::  (app_table[1] == true) ->
            atomic {
                do
                ::  AppCont?(mess_app_cont, id_flow_app);
                    goto S2;
                ::  ContCh1!GetFlow(1);
                    mess = GetFlow;
                    flow_id = 1;
                    goto S1;
                ::  Ch2Cont?FlowExpire(id_flow_cont);
                    ContApp!FlowExpire(id_flow_cont);
                    app_table[id_flow_cont] = false;
                    mess = FlowExpire;
                    flow_id = id_flow_cont;
                    goto S2;
                ::  Ch2Cont?ReplyFlow(id_flow_cont);
                    ContApp!ReplyFlow(id_flow_cont);
                    ContCh1!DelFlow(id_flow_cont);
                    app_table[id_flow_cont] = false;
                    mess = DelFlow;
                    flow_id = id_flow_cont;
                    goto S0;
                od;
            }
        ::  (app_table[2] == true) ->
            atomic {
                do
                ::  AppCont?(mess_app_cont, id_flow_app);
                    goto S2;
                ::  ContCh1!GetFlow(2);
                    mess = GetFlow;
                    flow_id = 2;
                    goto S1;
                ::  Ch2Cont?FlowExpire(id_flow_cont);
                    ContApp!FlowExpire(id_flow_cont);
                    app_table[id_flow_cont] = false;
                    mess = FlowExpire;
                    flow_id = id_flow_cont;
                    goto S2;
                ::  Ch2Cont?ReplyFlow(id_flow_cont);
                    ContApp!ReplyFlow(id_flow_cont);
                    ContCh1!DelFlow(id_flow_cont);
                    app_table[id_flow_cont] = false;
                    mess = DelFlow;
                    flow_id = id_flow_cont;
                    goto S0;
                od;
            }
        ::  timeout -> 
                deadlock = true;
        fi;
}

proctype Channel1(chan ContCh1, Ch1Switch) {
    int index_channel1;
    S0: do
        ::  ContCh1?PostFlow(index_channel1);
            Ch1Switch!PostFlow(index_channel1);
            goto S0;
        ::  ContCh1?GetFlow(index_channel1);
            Ch1Switch!GetFlow(index_channel1);
            goto S0;
        ::  ContCh1?DelFlow(index_channel1);
            Ch1Switch!DelFlow(index_channel1);
            goto S0;
        ::  timeout -> 
                deadlock = true;
        od;
}

proctype Channel2(chan SwitchCh2, Ch2Cont) {
    int index_channel2;
    S0: do
        ::  SwitchCh2?FlowExpire(index_channel2);
            Ch2Cont!FlowExpire(index_channel2);
            goto S0;
        ::  SwitchCh2?ReplyFlow(index_channel2);
            Ch2Cont!ReplyFlow(index_channel2);
            goto S0;
        ::  timeout -> 
                deadlock = true;
        od;
}

proctype Switch(chan Ch1Switch, SwitchCh2) {
    int index_flow_switch;
    S0: if
        ::  atomic {
                Ch1Switch?PostFlow(index_flow_switch);
                switch_table[index_flow_switch] = true;
                goto S0;
            }
        ::  atomic {
                Ch1Switch?GetFlow(index_flow_switch);
                SwitchCh2!ReplyFlow(index_flow_switch);
                goto S0;
            }
        ::  atomic {
                Ch1Switch?DelFlow(index_flow_switch);
                switch_table[index_flow_switch] = false;
                goto S0;
            }
        ::  (switch_table[0] == true) ->
            atomic {
                do    
                ::  SwitchCh2!FlowExpire(0);
                    switch_table[0] = false;
                    switch_id = 0;
                    goto S0;
                ::  Ch1Switch?PostFlow(index_flow_switch);
                    switch_table[index_flow_switch] = true;
                    goto S0;
                ::  Ch1Switch?GetFlow(index_flow_switch);
                    SwitchCh2!ReplyFlow(index_flow_switch);
                    goto S0;
                ::  Ch1Switch?DelFlow(index_flow_switch);
                    mess_switch = DelFlow;
                    switch_table[index_flow_switch] = false;
                    goto S0;
                od;
            }
        ::  (switch_table[1] == true) ->
            atomic {
                do    
                ::  SwitchCh2!FlowExpire(1);
                    switch_table[1] = false;
                    switch_id = 1;
                    goto S0;
                ::  Ch1Switch?PostFlow(index_flow_switch);
                    switch_table[index_flow_switch] = true;
                    goto S0;
                ::  Ch1Switch?GetFlow(index_flow_switch);
                    SwitchCh2!ReplyFlow(index_flow_switch);
                    goto S0;
                ::  Ch1Switch?DelFlow(index_flow_switch);
                    mess_switch = DelFlow;
                    switch_table[index_flow_switch] = false;
                    goto S0;
                od;
            }
        ::  (switch_table[2] == true) ->
            atomic {
                do    
                ::  SwitchCh2!FlowExpire(2);
                    switch_table[2] = false;
                    switch_id = 2;
                    goto S0;
                ::  Ch1Switch?PostFlow(index_flow_switch);
                    switch_table[index_flow_switch] = true;
                    goto S0;
                ::  Ch1Switch?GetFlow(index_flow_switch);
                    SwitchCh2!ReplyFlow(index_flow_switch);
                    goto S0;
                ::  Ch1Switch?DelFlow(index_flow_switch);
                    mess_switch = DelFlow;
                    switch_table[index_flow_switch] = false;
                    goto S0;
                od;
            }
        ::  timeout -> 
                deadlock = true;
        fi;
}

init {

    chan AppCont = [0] of { mtype, int };
    chan ContApp = [0] of { mtype, int };
    chan ContCh1 = [0] of { mtype, int };
    chan Ch1Switch = [0] of { mtype, int };
    chan SwitchCh2 = [0] of { mtype, int };
    chan Ch2Cont = [0] of { mtype, int };    
    
    atomic {
        run Application(ContApp, AppCont);
        run Controller(AppCont, ContApp, Ch2Cont, ContCh1);
        run Channel1(ContCh1, Ch1Switch);
        run Channel2(SwitchCh2, Ch2Cont);
        run Switch(Ch1Switch, SwitchCh2);
    }
}

ltl f {[](
    (((mess == DelFlow) && (flow_id == 0)) -> (app_table[0] == true)) &&
    (((mess == DelFlow) && (flow_id == 1)) -> (app_table[1] == true)) &&
    (((mess == DelFlow) && (flow_id == 2)) -> (app_table[2] == true))
    )}
ltl f2 {[](
    (((mess_switch == DelFlow) && (flow_id == 0)) -> (switch_table[0] == true)) &&
    (((mess_switch == DelFlow) && (flow_id == 1)) -> (switch_table[1] == true)) &&
    (((mess_switch == DelFlow) && (flow_id == 2)) -> (switch_table[2] == true))
    )}
//ltl f1 {[](((mess == DelFlow) && (flow_id == 0)) -> (switch_table[0] == true))}
//ltl f4 {!(<>(mess == DelFlow))}
