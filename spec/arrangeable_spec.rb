require 'spec_helper'

RSpec.describe ActiveRecord::Arrangeable do
  class City < ActiveRecord::Base
    include ActiveRecord::Arrangeable

    scope :actives, ->() { where(active: true) }

    has_many :provinces

    arrange_by :province_name, (lambda do |direction=:asc|
      includes(:provinces).order("provinces.name #{direction}")
    end)
  end
  class Province < ActiveRecord::Base
    belongs_to :city
  end

  before do
    City.unscoped.destroy_all
  end

  {model: City, all: City.all, scope: City.actives}.each do |explanation, subject|
    describe explanation do
      let(:subject_sort_by) { subject.respond_to?(:subject) ? subject : subject.all }

      context 'when custom arrange_by is used in isolation' do
        let(:sorted_cities) { subject_sort_by.sort_by { |city| city.provinces.map(&:name) } }

        before do
          City.create(active: false)
          City.create(name: 'city2', provinces: [Province.create(name: 'c3'),
                                                 Province.create(name: 'd4')])
          City.create(name: 'city1', provinces: [Province.create(name: 'a1'),
                                                 Province.create(name: 'b2')])
        end

        context 'with symbol' do
          it 'sorts ascending by default' do
            expect(subject.arrange(:province_name).map(&:id)).to eq(sorted_cities.map(&:id))
          end
        end

        context 'with string' do
          it 'sorts ascending by default' do
            expect(subject.arrange('province_name').map(&:id)).to eq(sorted_cities.map(&:id))
          end
        end

        context 'with hash' do
          it 'sorts descending' do
            expect(subject.arrange(province_name: :desc).map(&:id)).to eq(
              sorted_cities.map(&:id).reverse
            )
          end

          it 'sorts ascending' do
            expect(subject.arrange(province_name: :asc).map(&:id)).to eq(sorted_cities.map(&:id))
          end
        end

        context 'with an array' do
          it 'sorts descending' do
            expect(subject.arrange([province_name: :desc]).map(&:id)).to eq(
              sorted_cities.map(&:id).reverse
            )
          end

          it 'sorts ascending' do
            expect(subject.arrange([province_name: :asc]).map(&:id)).to eq(sorted_cities.map(&:id))
          end
        end
      end

      context 'when custom arrange_by is combined with attrs' do
        let(:sorted_cities_asc) do
          subject_sort_by.sort_by { |city| [city.provinces.map(&:name), city.name] }.map(&:id)
        end
        let(:sorted_cities_desc) do
          subject_sort_by.sort_by { |city| [city.provinces.map(&:name), city.name] }.map(&:id).reverse
        end
        let(:sorted_cities_desc_asc) do
          subject_sort_by.sort do |c1, c2|
            [c2.provinces.map(&:name), c1.name] <=> [c1.provinces.map(&:name), c2.name]
          end.map(&:id)
        end
        let(:sorted_cities_asc_desc) do
          subject_sort_by.sort do |c1, c2|
            [c1.provinces.map(&:name), c2.name] <=> [c2.provinces.map(&:name), c1.name]
          end.map(&:id)
        end

        before do
          City.create(name: 'city2', provinces: [Province.create(name: 'c3'),
                                                 Province.create(name: 'd4')])
          City.create(name: 'city3', provinces: [Province.create(name: 'a1'),
                                                 Province.create(name: 'b2')])
          City.create(name: 'city1', provinces: [Province.create(name: 'a1'),
                                                 Province.create(name: 'b2')])
        end

        it 'sorts ascending' do
          expect(subject.arrange([province_name: :asc], name: :asc).map(&:id)).to eq(sorted_cities_asc)
        end

        it 'sorts descending' do
          expect(subject.arrange([province_name: :desc], name: :desc).map(&:id)).to eq(
            sorted_cities_desc
          )
        end

        it 'provinces desc, name asc' do
          expect(subject.arrange([province_name: :desc], name: :asc).map(&:id)).to eq(
            sorted_cities_desc_asc
          )
        end

        it 'provinces asc, name desc' do
          expect(subject.arrange([province_name: :asc], name: :desc).map(&:id)).to eq(
            sorted_cities_asc_desc
          )
        end
      end
    end
  end
end
