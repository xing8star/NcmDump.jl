module NcmDump
 	
    using Base64:base64decode
    import JSON3
    using AES

    const core_key = hex2bytes("687A4852416D736F356B496E62617857")
    const meta_key = hex2bytes("2331346C6A6B5F215C5D2630553C2728")
    function ncmdecode(file_path)

        f = open(file_path, "r")
        header = read(f,8)

        @assert header == hex2bytes("4354454e4644414d") error("not is a ncm file")
        skip(f,2)
        key_length = read(f,4)

        unpack(data)=parse(Int,"0x"*bytes2hex(reverse(data)))

        key_length=unpack(key_length)
        key_data = read(f,key_length)

        key_data.⊻= 0x64

        cryptor = AESCipher(;key_length=128, mode=AES.ECB, key=AES128Key(core_key))
        ct=AES.CipherText(key_data,nothing,128,AES.ECB)

        key_data = String(decrypt(ct, cryptor)[18:end])
        key_length = length(key_data)

        key_data=UInt8.(collect(key_data))

        key_box = UInt8.(0:255)
        c = 0
        last_byte = 0
        key_offset = 1

        for i in 1:256
            swap = key_box[i]
            c = (swap + last_byte + key_data[key_offset]) & 0xff
            key_offset += 1
            if key_offset > key_length
                key_offset = 1
            end
            key_box[i] = key_box[c+1]
            key_box[c+1] = swap
            last_byte = c
        end
        meta_length = read(f,4)

        meta_length = unpack(meta_length)
        meta_data = read(f,meta_length)

        meta_data.⊻= 0x63

        meta_data = base64decode(meta_data[22:end])

        cryptor = AESCipher(;key_length=128, mode=AES.ECB, key=AES128Key(meta_key))
        ct=AES.CipherText(meta_data,nothing,128,AES.ECB)

        meta_data= String(decrypt(ct, cryptor)[7:end])

        meta_data = JSON3.read(meta_data)
        crc32 = read(f,4)
        crc32 = unpack(crc32)
        skip(f,5)
        image_size = read(f,4)
        image_size = unpack(image_size)
        image_data = read(f,image_size)
        file_upper_path,_=splitext(file_path)
        open(file_upper_path*".jpg", "w") do io
        	write(io,image_data)
        end
        file_name = joinpath(file_upper_path* '.' * meta_data["format"])
        m = open(file_name, "w")

        while true
            chunk = read(f,0x8000)
            chunk_length = length(chunk)
            if chunk_length==0 break end
            for i in 1:chunk_length
                j = i & 0xff
                index=(key_box[j+1] + key_box[((key_box[j+1] + j) & 0xff) + 1]) & 0xff
                chunk[i] ⊻= key_box[index+1]
            end
            write(m,chunk)
        end

        close(f)
        close(m)
    end
    function julia_main()::Cint
        for i in ARGS
            println(i)
            if isdirpath(i)
                files=first(walkdir(i))[3]
                files=i.*files
                Threads.@threads :dynamic for z in files
                println(z)
                    ncmdecode(z)
                end
            else
                ncmdecode(i)
            end
        end
        return 0 
    end
    export ncmdecode
end


