# first line: 378
@_utils.fill_doc
def compute_background_mask(data_imgs, border_size=2,
                            connected=False, opening=False,
                            target_affine=None, target_shape=None,
                            memory=None, verbose=0):
    """Compute a brain mask for the images by guessing the value of the
    background from the border of the image.

    Parameters
    ----------
    data_imgs : Niimg-like object
        See http://nilearn.github.io/manipulating_images/input_output.html
        Images used to compute the mask. 3D and 4D images are accepted.

        .. note::

            If a 3D image is given, we suggest to use the mean image.

    %(border_size)s
        Default=2.
    %(connected)s
        Default=False.
    %(opening)s
        Default=False.
    %(target_affine)s

        .. note::
            This parameter is passed to :func:`nilearn.image.resample_img`.

    %(target_shape)s

        .. note::
            This parameter is passed to :func:`nilearn.image.resample_img`.

    %(memory)s
    %(verbose0)s

    Returns
    -------
    mask : :class:`nibabel.nifti1.Nifti1Image`
        The brain mask (3D image).
    """
    if verbose > 0:
        print("Background mask computation")

    data_imgs = _utils.check_niimg(data_imgs)

    # Delayed import to avoid circular imports
    from .image.image import _compute_mean
    data, affine = cache(_compute_mean, memory)(data_imgs,
                                                target_affine=target_affine,
                                                target_shape=target_shape,
                                                smooth=False)

    if np.isnan(get_border_data(data, border_size)).any():
        # We absolutely need to catter for NaNs as a background:
        # SPM does that by default
        mask = np.logical_not(np.isnan(data))
    else:
        background = np.median(get_border_data(data, border_size))
        mask = data != background

    mask, affine = _post_process_mask(mask, affine, opening=opening,
                                      connected=connected,
                                      warning_msg="Are you sure that input "
                                      "images have a homogeneous background.")
    return new_img_like(data_imgs, mask, affine)
