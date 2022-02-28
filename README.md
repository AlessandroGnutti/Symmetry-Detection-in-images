# Combining Appearance and Gradient Information for Image Symmetry Detection

This work addresses the challenging problem of reflection symmetry detection in unconstrained environments. Starting from the understanding on how the visual cortex manages planar symmetry detection, it is proposed to treat the problem in two stages: i) the design of a stable metric that extracts subsets of consistently oriented candidate segments, whenever the underlying 2D signal appearance exhibits definite near symmetric correspondences; ii) the ranking of such segments on the basis of the surrounding gradient orientation specularity, in order to reflect real symmetric object boundaries. Since these operations are related to the way the human brain performs planar symmetry detection, a better correspondence can be established between the outcomes of the proposed algorithm and a human-constructed ground truth. When compared to the testing sets used in recent symmetry detection competitions, a remarkable performance gain can be observed. In additional, further validation has been achieved by conducting perceptual validation experiments with users on a newly built dataset.

# Code

Download at https://drive.google.com/file/d/1wle6VTbuPhMT3hb2_HAW5cqzJ-hXpvBF/view?usp=sharing the .mat files associated to the symmetry stacks of the ICCV17, single axis, testset.

Copy the files in /DatasetICCV17/Testset/ref_s/stack/.

Run the main.m file.

# Citing

If you use this code in your work, please consider citing the following paper:

A. Gnutti, F. Guerrini and R. Leonardi, "Combining Appearance and Gradient Information for Image Symmetry Detection," in IEEE Transactions on Image Processing, vol. 30, pp. 5708-5723, 2021, doi: 10.1109/TIP.2021.3085202. https://ieeexplore.ieee.org/document/9459467

# Contacts

For any information, please send an email to alessandro.gnutti@unibs.it
