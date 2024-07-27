import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const INITIAL_ONERI_ESIGI = 100;

const PyschologyDAOModule = buildModule("PyschologyDAOModule", (m) => {
  const oneriEsigi = m.getParameter("oneriEsigi", INITIAL_ONERI_ESIGI);

  const psychologyDAO = m.contract("PyschologyDAO", [oneriEsigi]);

  return { psychologyDAO };
});

export default PyschologyDAOModule;
