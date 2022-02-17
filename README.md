# Combining Appearance and Gradient Information for Image Symmetry Detection

This work addresses the challenging problem of reflection symmetry detection in unconstrained environments. Starting from the understanding on how the visual cortex manages planar symmetry detection, it is proposed to treat the problem in two stages: i) the design of a stable metric that extracts subsets of consistently oriented candidate segments, whenever the underlying 2D signal appearance exhibits definite near symmetric correspondences; ii) the ranking of such segments on the basis of the surrounding gradient orientation specularity, in order to reflect real symmetric object boundaries. Since these operations are related to the way the human brain performs planar symmetry detection, a better correspondence can be established between the outcomes of the proposed algorithm and a human-constructed ground truth. When compared to the testing sets used in recent symmetry detection competitions, a remarkable performance gain can be observed. In additional, further validation has been achieved by conducting perceptual validation experiments with users on a newly built dataset.

# Running the code

Download at IN PROGRESS the .mat files associated to the symmetry stacks for the ICCV17, single axis, testset.

Copy the files in /DatasetICCV17/Testset/ref_s/stack/.

Run the main.m file.

# Contacts

For any information, please send an email to alessandro.gnutti@unibs.it
