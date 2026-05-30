-- hl.bind(mainMod .. " + L ", hl.dsp.submap("pypr_scratchpad_switch"))
-- hl.define_submap("pypr_scratchpad_switch", "reset", function()
-- 	hl.bind("1", hl.dsp.exec_cmd("pypr toggle term"))
-- 	hl.bind("2", hl.dsp.exec_cmd("pypr toggle zen"))
-- end)
--
-- hl.bind(mainMod .. " + L", function()
-- 	hl.dispatch(hl.dsp.exec_cmd(SCRIPTS .. "scratchpadWofi" .. ".sh"))
-- end)

hl.bind(mainMod .. "+SHIFT +L ", hl.dsp.exec_cmd("pypr hide '*'"))
hl.bind(mainMod .. "+ O ", hl.dsp.exec_cmd("pypr fetch_client_menu"))
hl.bind(mainMod .. "+ Z",hl.dsp.exec_cmd("pypr toggle term"))
