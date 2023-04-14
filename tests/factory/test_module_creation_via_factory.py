from brownie import reverts


def test_module_creation_via_factory(safe, module_factory):
    tx = module_factory.createModuleAndEnable(safe, 0, {"from": safe})

    module_deployed_event = tx.events["ModuleDeployed"]

    assert module_deployed_event["moduleType"] == 0
    assert module_deployed_event["deployer"] == safe.address


def test_module_creation_not_signer(module_factory, safe, accounts):
    with reverts():
        module_factory.createModuleAndEnable(safe, 100, {"from": accounts[5]})


def test_module_creation_not_valid_enum(module_factory, safe):
    with reverts():
        module_factory.createModuleAndEnable(safe, 100, {"from": safe})
