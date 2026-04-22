#uses "CtrlExtension"

bool dptExists(string dptName)
{
  dyn_string dptList;
  dptList = dpTypes();
  return dynContains(dptList, dptName) > 0;
}

void addLeaf(dyn_dyn_string &elements, dyn_dyn_int &types,
             int &idx, string root, string leaf, int leafType)
{
  idx++;
  elements[idx] = makeDynString(root, leaf, "", "");
  types[idx] = makeDynInt(0, leafType);
}

int createSimpleDpt(string dptName, dyn_string leaves, dyn_int leafTypes)
{
  dyn_dyn_string elements;
  dyn_dyn_int types;
  int i, idx = 1;

  elements[1] = makeDynString(dptName, "", "", "");
  types[1]    = makeDynInt(DPEL_STRUCT);

  for (i = 1; i <= dynlen(leaves); i++)
  {
    addLeaf(elements, types, idx, "", leaves[i], leafTypes[i]);
  }

  return dpTypeCreate(elements, types);
}

int ensureDpt_BaseObject()
{
  dyn_string leaves = makeDynString(
    "name", "desc", "sclClass", "uuid", "enabled", "iedName", "ldInst", "lnRefs"
  );
  dyn_int leafTypes = makeDynInt(
    DPEL_STRING, DPEL_STRING, DPEL_STRING, DPEL_STRING,
    DPEL_BOOL, DPEL_STRING, DPEL_STRING, DPEL_DYN_STRING
  );

  if (dptExists("IEC61850_BaseObject"))
  {
    DebugN("DPT already exists: IEC61850_BaseObject");
    return 0;
  }
  return createSimpleDpt("IEC61850_BaseObject", leaves, leafTypes);
}

int ensureDpt_Substation()
{
  dyn_string leaves = makeDynString("substationName");
  dyn_int leafTypes = makeDynInt(DPEL_STRING);

  if (dptExists("IEC61850_Substation"))
  {
    DebugN("DPT already exists: IEC61850_Substation");
    return 0;
  }
  return createSimpleDpt("IEC61850_Substation", leaves, leafTypes);
}

int ensureDpt_VoltageLevel()
{
  dyn_string leaves = makeDynString("substationRef", "voltage", "nomFreq");
  dyn_int leafTypes = makeDynInt(DPEL_STRING, DPEL_FLOAT, DPEL_FLOAT);

  if (dptExists("IEC61850_VoltageLevel"))
  {
    DebugN("DPT already exists: IEC61850_VoltageLevel");
    return 0;
  }
  return createSimpleDpt("IEC61850_VoltageLevel", leaves, leafTypes);
}

int ensureDpt_Bay()
{
  dyn_string leaves = makeDynString("substationRef", "voltageLevelRef", "bayFunction");
  dyn_int leafTypes = makeDynInt(DPEL_STRING, DPEL_STRING, DPEL_STRING);

  if (dptExists("IEC61850_Bay"))
  {
    DebugN("DPT already exists: IEC61850_Bay");
    return 0;
  }
  return createSimpleDpt("IEC61850_Bay", leaves, leafTypes);
}

int ensureDpt_ConductingEquipment()
{
  dyn_string leaves = makeDynString(
    "substationRef", "voltageLevelRef", "bayRef", "ceType", "terminals",
    "inService", "isSource", "canConduct", "energized", "switchClosed", "blocked"
  );
  dyn_int leafTypes = makeDynInt(
    DPEL_STRING, DPEL_STRING, DPEL_STRING, DPEL_STRING, DPEL_DYN_STRING,
    DPEL_BOOL, DPEL_BOOL, DPEL_BOOL, DPEL_BOOL, DPEL_BOOL, DPEL_BOOL
  );

  if (dptExists("IEC61850_ConductingEquipment"))
  {
    DebugN("DPT already exists: IEC61850_ConductingEquipment");
    return 0;
  }
  return createSimpleDpt("IEC61850_ConductingEquipment", leaves, leafTypes);
}

int ensureDpt_Terminal()
{
  dyn_string leaves = makeDynString(
    "equipmentRef", "connectivityNodeRef", "terminalNo", "side", "isConnected"
  );
  dyn_int leafTypes = makeDynInt(
    DPEL_STRING, DPEL_STRING, DPEL_INT, DPEL_STRING, DPEL_BOOL
  );

  if (dptExists("IEC61850_Terminal"))
  {
    DebugN("DPT already exists: IEC61850_Terminal");
    return 0;
  }
  return createSimpleDpt("IEC61850_Terminal", leaves, leafTypes);
}

int ensureDpt_ConnectivityNode()
{
  dyn_string leaves = makeDynString(
    "substationRef", "voltageLevelRef", "bayRef", "pathName", "neighborTerminals",
    "isBusLike", "isSource", "energized", "topoVisited"
  );
  dyn_int leafTypes = makeDynInt(
    DPEL_STRING, DPEL_STRING, DPEL_STRING, DPEL_STRING, DPEL_DYN_STRING,
    DPEL_BOOL, DPEL_BOOL, DPEL_BOOL, DPEL_BOOL
  );

  if (dptExists("IEC61850_ConnectivityNode"))
  {
    DebugN("DPT already exists: IEC61850_ConnectivityNode");
    return 0;
  }
  return createSimpleDpt("IEC61850_ConnectivityNode", leaves, leafTypes);
}

main()
{
  int rc;
  bool ok = TRUE;

  DebugN("=== Create topology DPT model: start ===");

  rc = ensureDpt_BaseObject();
  if (rc != 0) { ok = FALSE; DebugN("Create failed: IEC61850_BaseObject rc=", rc, " err=", getLastError()); }

  rc = ensureDpt_Substation();
  if (rc != 0) { ok = FALSE; DebugN("Create failed: IEC61850_Substation rc=", rc, " err=", getLastError()); }

  rc = ensureDpt_VoltageLevel();
  if (rc != 0) { ok = FALSE; DebugN("Create failed: IEC61850_VoltageLevel rc=", rc, " err=", getLastError()); }

  rc = ensureDpt_Bay();
  if (rc != 0) { ok = FALSE; DebugN("Create failed: IEC61850_Bay rc=", rc, " err=", getLastError()); }

  rc = ensureDpt_ConductingEquipment();
  if (rc != 0) { ok = FALSE; DebugN("Create failed: IEC61850_ConductingEquipment rc=", rc, " err=", getLastError()); }

  rc = ensureDpt_Terminal();
  if (rc != 0) { ok = FALSE; DebugN("Create failed: IEC61850_Terminal rc=", rc, " err=", getLastError()); }

  rc = ensureDpt_ConnectivityNode();
  if (rc != 0) { ok = FALSE; DebugN("Create failed: IEC61850_ConnectivityNode rc=", rc, " err=", getLastError()); }

  if (ok)
    DebugN("=== Create topology DPT model: done ===");
  else
    DebugN("=== Create topology DPT model: finished with errors ===");
}
