import TermHeader from './partials/term-header';
import TermFooter from './partials/term-footer';
import SignatureMark from '../signature-mark';
import termData from './term-data';

export default {
  mixins: [termData],

  components: { TermHeader, TermFooter, SignatureMark },

  props: {
    documentId: {
      type: Number,
      required: true
    },
  },

  data() {
    return {
      open: false,
      request: {
        new_orientation: {
          advisor: {
            id: '',
            name: ''
          },
          professorSupervisors: [],
          externalMemberSupervisors: [],
        },
        requester: {
          justification: '',
        },
        judgment: {
          responsible: {
            id: '',
            accept: false,
            justification: ''
          },
        },
      },
    };
  },

  computed: {
    urlSignatureData() {
      return `/documents/${this.documentId}/data`;
    },

    externalMemberSupervisorLabel() {
      return this.term.externalMemberSupervisors.length === 1
        ? 'Coorientador externo'
        : 'Coorientadores externos';
    },

    professorSupervisorLabel() {
      return this.term.professorSupervisors.length === 1
        ? 'Coorientador da UTFPR'
        : 'Coorientadores da UTFPR';
    },
  },

  mounted() {
    this.onCloseTerm();
    this.onOpenTerm();
    this.onUpdateRequest();
    this.setData();
  },

  methods: {
    async setData(url = this.urlSignatureData) {
      const response = await this.$axios.post(url);

      if (response.data.status !== 'not_found') {
        this.term = response.data;
        this.open = true;
        this.setRequest();
      }
    },

    async setRequest() {
      const url = `/documents/${this.term.document.id}/request`;
      const response = await this.$axios.post(url);
      this.request = response.data;
    },

    hasProfessorSupervisors() {
      return this.term.professorSupervisors.length > 0;
    },

    hasExternalMemberSupervisors() {
      return this.term.externalMemberSupervisors.length > 0;
    },

    hasInstitution() {
      return this.term.institution.responsible !== null && this.term.institution.trade_name !== null;
    },

    hasObs() {
      return this.term.document.obs !== undefined;
    },

    onUpdateRequest() {
      this.$root.$on('update-json-request', () => {
        this.setRequest();
      });
    },

    onCloseTerm() {
      this.$root.$on('close-term', () => { this.open = false; });
    },

    onOpenTerm() {
      this.$root.$on('open-term', () => { this.open = true; });
    },
  },
};
