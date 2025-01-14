# encoding: UTF-8
#
# Copyright (c) 2010-2017 GoodData Corporation. All rights reserved.
# This source code is licensed under the BSD-style license found in the
# LICENSE file in the root directory of this source tree.

describe GoodData::LCM2::CollectUsersBrickUsers do
  let(:data_source) { double('data_source') }
  let(:users_csv) do
  end

  let(:params) do
    params = {
      users_brick_config: {
        input_source: {},
        login_column: 'Email'
      },
      sync_mode: 'sync_domain_client_workspaces',
      multiple_projects_column: 'client_id'
    }
    GoodData::LCM2.convert_to_smart_hash(params)
  end

  before do
    allow(GoodData::Helpers::DataSource).to receive(:new).and_return(data_source)
    allow(data_source).to receive(:realize).and_return('spec/data/users.csv')
  end

  it 'enriches parameters with logins' do
    result = subject.class.call(params)
    expect(result[:params][:users_brick_users].length).to eq(11)
    result[:params][:users_brick_users].each do |user|
      expect(user[:login]).not_to be_nil
    end
  end

  context 'when multiple_projects_column is not set' do
    before do
      allow(data_source).to receive(:realize).and_return('spec/data/users_without_multiple_projects_column.csv')
    end

    it 'fails' do
      expect { subject.class.call(params) }.to raise_error(/of the users input is empty/)
    end
  end
end
