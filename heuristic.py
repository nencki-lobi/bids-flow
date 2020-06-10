import os
import re
from collections import defaultdict

t_r_regex = re.compile(
    'task-(?P<tasklabel>[a-zA-Z]+)_run-(?P<runlabel>[0-9]+)')


def get_dim4_and_numeric_id(x):
    """A helper function for sorting"""
    return((x.dim4, int(re.match('[0-9]+', x.series_id).group())))


def find_repeated(seqinfo):
    """Create a list of series_ids from repeated runs
    Assumes that a run should be excluded on two criterions, in this order:
    1. if there are longer runs of the given task (sort by dim4)
       (interrruptions happen, but duration is usually constant)
    2. if there are subsequent runs of the given task (sort by series_id)
       (completed run may be repeated by experimenter's decision)
    """
    exclusions = []

    # find all sequences that have task & run defined in the name
    # and collect them into a dictionary (tasklabel, runlabel): [seqinfos]
    matching = defaultdict(list)
    for s in seqinfo:
        match = re.match(t_r_regex, s.protocol_name)
        if match is not None:
            matching[match.groups()].append(s)

    # for each task-run pair, pick series_ids to be excluded
    for s_list in matching.values():
        if len(s_list) > 1:
            # more than 1 occurence of task&run
            # sort by dim4 and then series_id
            s_list.sort(key=get_dim4_and_numeric_id)
            # list all but one for exclusion
            for i in range(len(s_list) - 1):
                exclusions.append(s_list[i].series_id)
    return exclusions


def create_key(template, outtype=('nii.gz',), annotation_classes=None):
    if template is None or not template:
        raise ValueError('Template must be a valid format string')
    return template, outtype, annotation_classes


def filter_files(fl):
    if os.path.basename(fl) in ['busy', '.DS_Store']:
        return False
    return True


def infotoids(seqinfos, outdir):
    seqinfos = list(seqinfos)
    subject = fixup_subjectid(seqinfos[0].patient_id)
    return {
        'subject': subject,
        'session': seqinfos[0].date}


def infotodict(seqinfo):
    """Heuristic evaluator for determining which runs belong where

    A few fields are defined by default:

    item: index within category
    subject: participant id
    seqitem: run number during scanning
    subindex: sub index within group
    """

    t1w = create_key(
        'sub-{subject}/{session}/anat/sub-{subject}_{session}_T1w')
    task_run = create_key(
        'sub-{subject}/{session}/func/sub-{subject}_{session}_task-{tasklabel}_run-{runlabel}'
        '_bold')
    bold = create_key(
        'sub-{subject}/{session}/func/sub-{subject}_{session}_task-fmri_run-{item:01d}_bold')
    rest = create_key(
        'sub-{subject}/{session}/func/sub-{subject}_{session}_task-rest_run-{item:01d}_bold')
    fmap_phasediff = create_key(
        'sub-{subject}/{session}/fmap/sub-{subject}_{session}_phasediff')
    fmap_magnitude = create_key(
        'sub-{subject}/{session}/fmap/sub-{subject}_{session}_magnitude')

    info = {t1w: [], rest: [], bold: [], fmap_phasediff: [],
            fmap_magnitude: [], task_run: []}

    # check if any task-<>_run-<> repeats and should be excluded
    exclusions = find_repeated(seqinfo)

    for idx, s in enumerate(seqinfo):

        t_r_match = re.match(t_r_regex, s.protocol_name)  # task-<>_run-<>

        if s.series_id in exclusions:
            #  todo: think of some logging
            continue

        # s is a namedtuple with fields equal to the names of the columns
        # found in dicominfo.txt
        if ('t1_mpr' in s.protocol_name) or ('T1w' in s.protocol_name) or ('t1w' in s.protocol_name):
            if not s.is_derived:  # MPR Range recos etc
                info[t1w] = [s.series_id]
        elif s.protocol_name == 'gre_field_mapping' and s.image_type[2] == 'M':
            print("omit FM")
            # info[fmap_magnitude].append(s.series_id)
        elif s.protocol_name == 'gre_field_mapping' and s.image_type[2] == 'P':
            print("omit FM")
            # info[fmap_phasediff].append(s.series_id)
        elif t_r_match is not None:
            info[task_run].append(
                {'item': s.series_id,
                 'tasklabel': t_r_match.group('tasklabel'),
                 'runlabel': t_r_match.group('runlabel')
                 })
        elif ('rest' in s.protocol_name):
            info[rest].append(s.series_id)
        elif ('ep2d_bold' in s.protocol_name) or ('task' in s.protocol_name) or ('FMRI' in s.protocol_name):
            info[bold].append(s.series_id)
    return info


def fixup_subjectid(subjectid):
    return re.sub('[-_]', '', subjectid)
