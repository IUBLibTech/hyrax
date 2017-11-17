RSpec.describe Hyrax::EmbargoService, :clean_repo do
  let(:service) { described_class }

  let(:future_date) { 2.days.from_now }
  let(:past_date) { 2.days.ago }

  let(:expired_embargo) do
    create_for_repository(:embargo, embargo_release_date: [past_date])
  end
  let(:current_embargo) do
    create_for_repository(:embargo, embargo_release_date: [future_date])
  end
  let!(:work_with_expired_embargo1) do
    create_for_repository(:work, embargo_id: expired_embargo.id)
  end

  let!(:work_with_expired_embargo2) do
    create_for_repository(:work, embargo_id: expired_embargo.id)
  end

  let!(:work_with_embargo_in_effect) { create_for_repository(:work, embargo_id: current_embargo.id) }
  let!(:work_without_embargo) { create_for_repository(:work) }

  describe '#assets_with_expired_embargoes' do
    subject { service.assets_with_expired_embargoes.map(&:id) }

    it 'returns an array of assets with expired embargoes' do
      expect(subject).to contain_exactly(
        work_with_expired_embargo1.id.to_s,
        work_with_expired_embargo2.id.to_s
      )
    end
  end

  describe '#assets_under_embargo' do
    subject { service.assets_under_embargo.map(&:id).map(&:to_s) }

    it 'returns all assets with embargo release date set' do
      expect(subject).to contain_exactly(
        work_with_expired_embargo1.id.to_s,
        work_with_expired_embargo2.id.to_s,
        work_with_embargo_in_effect.id.to_s
      )
    end
  end

  describe '#assets_with_deactivated_embargoes' do
    let(:id) { Noid::Rails::Service.new.mint }
    let(:attributes) do
      { 'embargo_history_ssim' => ['This is in the past'],
        'id' => id }
    end

    before do
      ActiveFedora::SolrService.add(attributes)
      ActiveFedora::SolrService.commit
    end

    it 'returns all assets with embargo history set' do
      returned_pids = subject.assets_with_deactivated_embargoes.map(&:id)
      expect(returned_pids).to include id
      expect(returned_pids).not_to include(work_without_embargo.id,
                                           work_with_expired_embargo1.id,
                                           work_with_expired_embargo2.id,
                                           work_with_embargo_in_effect.id)
    end
  end
end
