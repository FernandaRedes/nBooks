
describe "GET /books" do
    before do
        @resp = BaseApi.get("/books")
    end

    it "deve retornar 200" do
        expect(@resp.code).to eql 200
    end

    it "deve retornar uma lista" do
        # puts @resp.parsed_response
        # puts @resp.parsed_response.class
        # puts @resp.parsed_response.class.size

        #tamanho ou array fazem a mesma validação
        expect(@resp.parsed_response.size).to be >=0
        expect(@resp.parsed_response.class).to eql Array
    end
end

describe "GET /books/:_id" do
    
    #Context é como se fosse um cenario
    context "quando busco pelo id" do
        before do
            @payload = { title: "Helena", author: "Machado de Assis", isbn: Faker::Code.isbn }

            book = BaseApi.post("/books", body: @payload.to_json)
            book_id = book.parsed_response["_id"]
            # puts @resp.parsed_response

            #faz uma busca pelo identificador
            @resp = BaseApi.get("/books/#{book_id}")
        end

        it "deve retornar 200" do
            # puts @resp.parsed_response
            expect(@resp.code).to eql 200
        end

        it "deve retornar os dados" do
            # puts @resp.parsed_response
            # puts @payload
            expect(@resp.parsed_response["title"]).to eql @payload[:title]
            expect(@resp.parsed_response["author"]).to eql @payload[:author]
            expect(@resp.parsed_response["isbn"]).to eql @payload[:isbn]
        end
    end

    context "quando o id não existe" do
        before do
            book_id = Faker::Alphanumeric.alpha(number: 24)
            @resp = BaseApi.get("/books/#{book_id}")
        end

       it "deve retornar 404" do
            expect(@resp.code).to eql 404
       end
       it "deve retornar o json vazio" do
            # puts @resp.parsed_response
            expect(@resp.parsed_response).to be_empty
       end
    end
end