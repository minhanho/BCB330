import os

import scipy as sp
import scipy.misc

import imreg_dft as ird


basedir = os.path.join('/Users/minhanho/Documents/BCB330/data', 'processed')
# the TEMPLATE
im0 = sp.misc.imread(os.path.join(basedir, "cell1772058148−A01.png"), True)
# the image to be transformed
im1 = sp.misc.imread(os.path.join(basedir, "cell1772058148−A03.png"), True)
result = ird.similarity(im0, im1, numiter=3)

assert "timg" in result
# Maybe we don't want to show plots all the time
if os.environ.get("IMSHOW", "yes") == "yes":
    import matplotlib.pyplot as plt
    ird.imshow(im0, im1, result['timg'])
    plt.show()