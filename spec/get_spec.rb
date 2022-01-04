
describe "GET /" do
    before do
        @resp = BaseApi.get("/")
    end

    it "deve retornar 200" do
        expect(@resp.code).to eql 200
    end

    it "deve retornar welcome" do
        # puts resp.parsed_response
        # puts resp.parsed_response["message"]
        expect(@resp.parsed_response["message"]).to eql "Welcome to Book Api from QA Ninja!"
    end
end