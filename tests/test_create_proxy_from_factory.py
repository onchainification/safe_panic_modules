def test_get_chain_id(factory):
    chain_id = factory.getChainId()
    assert chain_id == 5
