require 'spec_helper'
require 'stringio'
require 'erb'

RSpec.describe WaterLevel do
  describe '.load' do
    subject { WaterLevel.load!(today: today) }
    let(:today) { Date.new(2021, 1, 2) }

    before { allow(WaterLevel).to receive(:open_water_levels_page).and_return(StringIO.new(html)) }
    let(:html) { ERB.new(File.read(__dir__ + '/water_level_page.html.erb')).result_with_hash(page_vars) }
    let(:page_vars) do
      {
        month: '1',
        data: {
          '1' => '10',
          '2' => '-20'
        }
      }
    end

    it '新規データを作成する' do
      expect { subject }.to change { WaterLevel.count }.from(0).to(2)

      levels = WaterLevel.order(day: :asc)
      levels[0].tap do |level|
        expect(level.day).to eq(Date.new(2021, 1, 1))
        expect(level.value).to eq(10)
      end
      levels[1].tap do |level|
        expect(level.day).to eq(Date.new(2021, 1, 2))
        expect(level.value).to eq(-20)
      end
    end

    context '既存データがあるとき' do
      let!(:levels) { WaterLevel.create(day: Date.new(2021, 1, 1), value: '1') }

      it '更新する' do
        expect { subject }.to change { WaterLevel.count }.from(1).to(2)

        levels = WaterLevel.order(day: :asc)
        levels[0].tap do |level|
          expect(level.day).to eq(Date.new(2021, 1, 1))
          expect(level.value).to eq(10)
        end
        levels[1].tap do |level|
          expect(level.day).to eq(Date.new(2021, 1, 2))
          expect(level.value).to eq(-20)
        end
      end
    end

    context '年の切り替わりなどで現在年だけが進んだとき' do
      let(:page_vars) { super().merge(month: '12') }

      it '12月のデータは未来なので無視する' do
        expect { subject }.not_to change { WaterLevel.count }.from(0)
      end
    end
  end
end
