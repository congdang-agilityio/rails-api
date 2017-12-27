require "spec_helper"

describe JsonWebToken, :type => :lib do
  let(:payload) {{user_id: 1, iat: 12345}}

  describe "encode", :jwt do
    context "when provide a paylod for encode" do
      it 'should return a jwt token' do
        jwt = JsonWebToken.encode(payload)
        expect(jwt.blank?).to_not eq true
      end
    end

    context "when provide an empty payload" do
      it 'should return an error' do
        jwt = JsonWebToken.encode({})
        expect(jwt).to eq 'You need provide a paylod for encode'
      end
    end
  end

  describe "decode", :jwt do
    let(:jwt) {JsonWebToken.encode(payload)}
    context "when provide an jwt for decode" do

      it 'should be return an object' do
        expect(jwt.blank?).to_not eq true
        payload = JsonWebToken.decode(jwt)
        expect(payload[:user_id]).to eq 1
        expect(payload[:iat]).to eq 12345
      end
    end

    context "when provide an empty token" do
      it 'should return a nil object' do
        expect(JsonWebToken.decode('')).to eq nil
      end
    end
  end
end
