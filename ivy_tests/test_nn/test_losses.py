
# global
import numpy as _np

# local
import ivy
import ivy_tests.helpers as helpers


def test_binary_cross_entropy():
    for lib, call in helpers.calls():
        assert _np.allclose(call(ivy.binary_cross_entropy, ivy.array([[0.3, 0.7, 0.5]], f=lib),
                                 ivy.array([[0., 1., 0.]], f=lib), f=lib),
                            _np.array([[0.35667494, 0.35667494, 0.69314718]]), atol=1e-6)
        if call in [helpers.torch_call]:
            # binary_cross_entropy does not have backend implementation,
            # pytorch scripting requires direct bindings to work, which bypass get_framework()
            continue
        helpers.assert_compilable('binary_cross_entropy', lib)
