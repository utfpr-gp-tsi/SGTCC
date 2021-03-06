export default {
  name: 'TermData',

  data() {
    return {
      term: {
        orientation: { id: '', title: '' },
        academic: { id: '', name: '', ra: '' },
        advisor: { id: '', name: '', label: '' },
        title: '',
        document: { id: '', created_at: '' },
        institution: {},
        professorSupervisors: [],
        externalMemberSupervisors: [],
        examination_board: []
      },
    };
  },
};
