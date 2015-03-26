--[[
 * Copyright (c) 2015 Pedro Souza <pedrosouza@freebsd.org>
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 * $FreeBSD$
 --]]
include("/boot/core.lua");
password = {};

function password.read()
    local str = "";
    local n = 0;
    
    repeat
        ch = io.getchar();
        if ch == 13 then break; end
        
        if ch == 8 then 
            if n > 0 then
                n = n - 1;
                print("\008");
                str = string.sub(str, 1, n);
            end
        else 
            print("*");
            str = str .. string.char(ch);
            n = n + 1;
        end
    until n == 16
    return str;
end

function password.check()
    local boot_pwd = loader.getenv("bootlock_password");
    if boot_pwd ~= nil then
        while true do
            print("Boot password: ");
            if boot_pwd == password.read() then break; end
            print("\nloader: incorrect password!\n");
            loader.delay(3*1000*1000);
        end
    end
    
    local pwd = loader.getenv("password");
    if (pwd == nil) then return; end
    
    core.autoboot();
    
    while true do
        print("Password: ");
        if pwd == password.read() then break; end
        print("\nloader: incorrect password!\n");
        loader.delay(3*1000*1000);
    end
end