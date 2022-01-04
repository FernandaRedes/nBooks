#app.rb
require "sinatra"
require "sinatra/namespace"
require "mongoid"

#DB connect
Mongoid.load! "mongoid.yml"

# Model
class Book
include Mongoid::Document 

    field :title, type: String
    field :author, type: String
    field :isbn, type: String
end

get "/" do
    content_type "application/json"
    return { message: "Welcome to Book Api from QA Ninja!" }.to_json
end

namespace "/books" do
    before do
        content_type "application/json"
    end
    get do
        # books = [
        #     { title: "Dom Casmurro", author: "Machado de Assis", isbn: "abc2001"},
        #     { title: "A marca de uma lágrima", author: "Pedro Bandeira", isbn: "abc2002"},
        #     { title: "Moby Dick", author: "Herman Mellville", isbn: "abc2003"},
        # ]
        # return books.to_json
        return Book.all.to_json 
    end

    get "/:book_id" do |book_id| 
        book = Book.where(_id: book_id).first

        unless book
            halt 404, {}.to_json
        end

        return book.to_json
    end

    delete "/:book_id" do |book_id| 
        book = Book.where(_id: book_id).first
        book.destroy if book 
        status 204
    end

    #try catch no ruby:
        # begin
        #     tenta alguma coisa
        # rescue
        #     obter um possível erro
    post do
        begin
            payload = JSON.parse(request.body.read)

            # if payload["title"]
            #     puts "o campo title foi preenchido"
            # end
            # unless payload["title"]
            #     puts "o campo title não foi preenchido"
            # end

            unless payload["title"]
                halt 409, { error: "Title is Required."}.to_json 
            end

            unless payload["author"]
                halt 409, { error: "Author is Required."}.to_json 
            end

            unless payload["isbn"]
                halt 409, { error: "ISBN is Required."}.to_json 
            end
            #Fazer uma busca no bd e retorna a informação na variável found
            #Caso caia nessa condição, o ruby não executa os restante do código
            found = Book.where(isbn: payload["isbn"]).first

            if found
                halt 409, { error: "Duplicated ISBN"}.to_json
            end

            # puts payload
            # puts payload.class
            book = Book.new(payload)
            book.save
            status 201
            return book.to_json 
        rescue => exception
            puts exception
            #halt recurso do sinatra para retornar erro
            halt 400, { error: exception}.to_json
        end        
    end

    #Sem o begin rescue, retorna erro 500 pq como json retorna vazio, não consegue converter vazio para json
    # post do
    #     payload = JSON.parse(request.body.read)
    #     book = Book.new(payload)
    #     book.save
    #     status 201
    #     return book.to_json        
    # end

end