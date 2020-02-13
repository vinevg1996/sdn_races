mtype = {
    PostFlow, GetFlow, DelFlow,
    FlowDelete, FlowExpire, ReplyFlow
}

mtype app_in_mess;
mtype app_out_mess;
bool app_table[3];
int id = 0;
int app_in_FD_id = 0;
int app_in_FE_id = 0;
int app_in_RF_id = 0;
/////////////////////
mtype cont_in_mess;
mtype cont_out_mess;
bool cont_table[3];
bool gf_flag;
bool df_flag;
int time_table[3];
int cont_id = 0;
int cont_in_PF_id = 0;
int cont_in_GF_id = 0;
int cont_in_DF_id = 0;
int cont_out_FE_id = 0;
int cont_out_RF_id = 0;
int cont_out_FD_id = 0;

proctype Application(chan ContApp, AppCont) {
    S0: 
        if
            ::  id = 0;
            ::  id = 1;
            ::  id = 2;
        fi;

        if
        ::  atomic {
                app_out_mess = PostFlow;
                AppCont!PostFlow(id);
                app_table[id] = 1;
                goto S1;
            }
        ::  (app_table[id] == 1) ->
            atomic {
                app_out_mess = GetFlow;
                AppCont!GetFlow(id);
                goto S2;
            }
        fi;

    S1: 
        if
            ::  id = 0;
            ::  id = 1;
            ::  id = 2;
        fi;

        if
        ::  atomic {
                app_out_mess = PostFlow;
                AppCont!PostFlow(id);
                app_table[id] = 1;
                goto S1;
            }
        ::  (app_table[id] == 1) ->
            atomic {
                app_out_mess = GetFlow;
                AppCont!GetFlow(id);
                goto S2;
            }
        ::  atomic {
                ContApp?FlowDelete(app_in_FD_id);
                app_in_mess = FlowDelete;
                app_table[app_in_FD_id] = 0;
                goto S1;
            }
        ::  atomic {
                ContApp?FlowExpire(app_in_FE_id);
                app_in_mess = FlowExpire;
                app_table[app_in_FE_id] = 0;
                goto S1;
            }
        ::  atomic {
                ContApp?ReplyFlow(app_in_RF_id);
                app_in_mess = ReplyFlow;
                goto S3;
            }
        fi;

    S2: 
        if
            ::  id = 0;
            ::  id = 1;
            ::  id = 2;
        fi;

        if
        ::  atomic {
                app_out_mess = PostFlow;
                AppCont!PostFlow(id);
                app_table[id] = 1;
                goto S1;
            }
        ::  (app_table[id] == 1) ->
            atomic {
                app_out_mess = GetFlow;
                AppCont!GetFlow(id);
                goto S2;
            }
        ::  atomic {
                ContApp?FlowDelete(app_in_FD_id);
                app_in_mess = FlowDelete;
                app_table[app_in_FD_id] = 0;
                goto S2;
            }
        ::  atomic {
                ContApp?FlowExpire(app_in_FE_id);
                app_in_mess = FlowExpire;
                app_table[app_in_FE_id] = 0;
                goto S2;
            }
        ::  atomic {
                ContApp?ReplyFlow(app_in_RF_id);
                app_in_mess = ReplyFlow;
                goto S3;
            }
        fi;

    S3: 
        if
            ::  id = 0;
            ::  id = 1;
            ::  id = 2;
        fi;

        if
        ::  atomic {
                app_out_mess = PostFlow;
                AppCont!PostFlow(id);
                app_table[id] = 1;
                goto S1;
            }
        ::  (app_table[id] == 1) ->
            atomic {
                app_out_mess = GetFlow;
                AppCont!GetFlow(id);
                goto S2;
            }
        ::  atomic {
                app_out_mess = DelFlow;
                AppCont!DelFlow(app_in_RF_id);
                goto S4;
            }
        ::  atomic {
                ContApp?FlowDelete(app_in_FD_id);
                app_in_mess = FlowDelete;
                app_table[app_in_FD_id] = 0;
                goto S3;
            }
        ::  atomic {
                ContApp?FlowExpire(app_in_FE_id);
                app_in_mess = FlowExpire;
                app_table[app_in_FE_id] = 0;
                goto S3;
            }
        ::  atomic {
                ContApp?ReplyFlow(app_in_RF_id);
                app_in_mess = ReplyFlow;
                goto S3;
            }
        fi;

    S4: 
        if
            ::  id = 0;
            ::  id = 1;
            ::  id = 2;
        fi;

        if
        ::  atomic {
                app_out_mess = PostFlow;
                AppCont!PostFlow(id);
                app_table[id] = 1;
                goto S1;
            }
        ::  (app_table[id] == 1) ->
            atomic {
                app_out_mess = GetFlow;
                AppCont!GetFlow(id);
                goto S2;
            }
        ::  atomic {
                app_out_mess = DelFlow;
                AppCont!DelFlow(app_in_RF_id);
                goto S4;
            }
        ::  atomic {
                ContApp?FlowDelete(app_in_FD_id);
                app_in_mess = FlowDelete;
                app_table[app_in_FD_id] = 0;
                goto S4;
            }
        ::  atomic {
                ContApp?FlowExpire(app_in_FE_id);
                app_in_mess = FlowExpire;
                app_table[app_in_FE_id] = 0;
                goto S4;
            }
        ::  atomic {
                ContApp?ReplyFlow(app_in_RF_id);
                app_in_mess = ReplyFlow;
                goto S3;
            }
        fi;
}

proctype ContAndSwitch(chan AppCont, ContApp) {
    S0: 
        if
        ::  atomic {
                AppCont?PostFlow(cont_in_PF_id);
                cont_in_mess = PostFlow;
                cont_table[cont_in_PF_id] = 1;
                time_table[cont_in_PF_id] = cont_in_PF_id;
                goto S1;
            }
        ::  atomic {
                AppCont?GetFlow(cont_in_GF_id);
                gf_flag = true;
                cont_in_mess = GetFlow;
                goto S2;
            }
        fi;

    S1: 
        time_table[0] = time_table[0] - 1;
        time_table[1] = time_table[1] - 1;
        time_table[2] = time_table[2] - 1;

        if 
            :: cont_out_FE_id = 0;
            :: cont_out_FE_id = 0;
            :: cont_out_FE_id = 0;
        fi;

        if
        ::  atomic {
                AppCont?PostFlow(cont_in_PF_id);
                cont_in_mess = PostFlow;
                cont_table[cont_in_PF_id] = 1;
                time_table[cont_in_PF_id] = cont_in_PF_id;
                goto S1;
            }
        ::  atomic {
                AppCont?GetFlow(cont_in_GF_id);
                gf_flag = true;
                cont_in_mess = GetFlow;
                goto S2;
            }
        ::  atomic {
                AppCont?DelFlow(cont_in_DF_id);
                df_flag = true;
                cont_table[cont_in_DF_id] = 0;
                cont_in_mess = DelFlow;
                goto S3;
            }
        ::  ((cont_table[cont_out_FE_id] == 1) && 
             (time_table[cont_out_FE_id] < 0)) -> 
            atomic {
                ContApp!FlowExpire(cont_out_FE_id);
                cont_table[cont_out_FE_id] = 0;
                cont_out_mess = FlowExpire;
                goto S1;
            }
        ::  (gf_flag == true) ->
            atomic {
                ContApp!ReplyFlow(cont_in_GF_id);
                cont_out_mess = ReplyFlow;
                gf_flag = false;
                goto S1;
            }
        ::  (df_flag == true) ->
            atomic {
                ContApp!FlowDelete(cont_in_DF_id);
                cont_out_mess = FlowDelete;
                df_flag = false;
                goto S1;
            }
        fi;

    S2: 
        time_table[0] = time_table[0] - 1;
        time_table[1] = time_table[1] - 1;
        time_table[2] = time_table[2] - 1;

        if 
            :: cont_out_FE_id = 0;
            :: cont_out_FE_id = 0;
            :: cont_out_FE_id = 0;
        fi;

        if
        ::  atomic {
                AppCont?PostFlow(cont_in_PF_id);
                cont_in_mess = PostFlow;
                cont_table[cont_in_PF_id] = 1;
                time_table[cont_in_PF_id] = cont_in_PF_id;
                goto S1;
            }
        ::  atomic {
                AppCont?GetFlow(cont_in_GF_id);
                gf_flag = true;
                cont_in_mess = GetFlow;
                goto S2;
            }
        ::  atomic {
                AppCont?DelFlow(cont_in_DF_id);
                df_flag = true;
                cont_table[cont_in_DF_id] = 0;
                cont_in_mess = DelFlow;
                goto S3;
            }
        ::  ((cont_table[cont_out_FE_id] == 1) && 
             (time_table[cont_out_FE_id] < 0)) -> 
            atomic {
                ContApp!FlowExpire(cont_out_FE_id);
                cont_table[cont_out_FE_id] = 0;
                cont_out_mess = FlowExpire;
                goto S2;
            }
        ::  (gf_flag == true) ->
            atomic {
                ContApp!ReplyFlow(cont_in_GF_id);
                cont_out_mess = ReplyFlow;
                gf_flag = false;
                goto S1;
            }
        ::  (df_flag == true) ->
            atomic {
                ContApp!FlowDelete(cont_in_DF_id);
                cont_out_mess = FlowDelete;
                df_flag = false;
                goto S1;
            }
        fi;

    S3: 
        time_table[0] = time_table[0] - 1;
        time_table[1] = time_table[1] - 1;
        time_table[2] = time_table[2] - 1;

        if 
            :: cont_out_FE_id = 0;
            :: cont_out_FE_id = 0;
            :: cont_out_FE_id = 0;
        fi;

        if
        ::  atomic {
                AppCont?PostFlow(cont_in_PF_id);
                cont_in_mess = PostFlow;
                cont_table[cont_in_PF_id] = 1;
                time_table[cont_in_PF_id] = cont_in_PF_id;
                goto S1;
            }
        ::  atomic {
                AppCont?GetFlow(cont_in_GF_id);
                gf_flag = true;
                cont_in_mess = GetFlow;
                goto S2;
            }
        ::  atomic {
                AppCont?DelFlow(cont_in_DF_id);
                df_flag = true;
                cont_table[cont_in_DF_id] = 0;
                cont_in_mess = DelFlow;
                goto S3;
            }
        ::  ((cont_table[cont_out_FE_id] == 1) && 
             (time_table[cont_out_FE_id] < 0)) -> 
            atomic {
                ContApp!FlowExpire(cont_out_FE_id);
                cont_table[cont_out_FE_id] = 0;
                cont_out_mess = FlowExpire;
                goto S2;
            }
        ::  (gf_flag == true) ->
            atomic {
                ContApp!ReplyFlow(cont_in_GF_id);
                cont_out_mess = ReplyFlow;
                gf_flag = false;
                goto S1;
            }
        ::  (df_flag == true) ->
            atomic {
                ContApp!FlowDelete(cont_in_DF_id);
                cont_out_mess = FlowDelete;
                df_flag = false;
                goto S3;
            }
        fi;
}

init {

    chan AppCont = [0] of { mtype, int };
    chan ContApp = [0] of { mtype, int };
    
    atomic {
        run Application(ContApp, AppCont);
        run ContAndSwitch(ContApp, AppCont);
    }
}

ltl f {[]((app_out_mess == PostFlow) -> <>(cont_in_mess == PostFlow))}