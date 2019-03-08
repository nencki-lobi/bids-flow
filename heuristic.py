def create_key(template, outtype=('nii.gz',), annotation_classes=None):
    if template is None or not template:
        raise ValueError('Template must be a valid format string')
    return template, outtype, annotation_classes


def infotodict(seqinfo):
    """Heuristic evaluator for determining which runs belong where

    A few fields are defined by default:

    item: index within category
    subject: participant id
    seqitem: run number during scanning
    subindex: sub index within group
    """

    t1w = create_key(
        'sub-{subject}/anat/sub-{subject}_T1w')
    bold = create_key(
        'sub-{subject}/func/sub-{subject}_task-fmri_run-{item:01d}_bold')
    rest = create_key(
        'sub-{subject}/func/sub-{subject}_task-rest_run-{item:01d}_bold')
    fmap_phasediff = create_key(
        'sub-{subject}/fmap/sub-{subject}_phasediff')
    fmap_magnitude = create_key(
        'sub-{subject}/fmap/sub-{subject}_magnitude')

    info = {t1w: [], rest: [], bold: [], fmap_phasediff: [],
            fmap_magnitude: []}

    for idx, s in enumerate(seqinfo):
        # s is a namedtuple with fields equal to the names of the columns
        # found in dicominfo.txt
        if ('t1_mpr' in s.protocol_name) or ('T1w' in s.protocol_name):
            if not s.is_derived:  # MPR Range recos etc
                info[t1w] = [s.series_id]
        elif s.protocol_name == 'gre_field_mapping' and s.image_type[2] == 'M':
            print("omit FM")
            # info[fmap_magnitude].append(s.series_id)
        elif s.protocol_name == 'gre_field_mapping' and s.image_type[2] == 'P':
            print("omit FM")
            # info[fmap_phasediff].append(s.series_id)
        elif ('rest' in s.protocol_name):
            info[rest].append(s.series_id)
        elif ('ep2d_bold' in s.protocol_name) or ('task' in s.protocol_name):
            info[bold].append(s.series_id)
    return info
