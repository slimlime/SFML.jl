# Not currently working because of Julia threading problems
type Thread
	ptr::Ptr{Void}

	function Thread(ptr::Ptr{Void})
		t = new(ptr)
		finalizer(t, destroy)
		t
	end
end

function Thread(callback::Function)
	callback_c = Base.SingleAsyncWork(data -> callback())

	async_send(func::Ptr{Void}) = (ccall(:uv_async_send, Cint, (Ptr{Void},), func); C_NULL)
	const c_async_send = cfunction(async_send, Ptr{Void}, (Ptr{Void},))

	Thread(ccall((:sfThread_create, "libcsfml-system"), Ptr{Void}, (Ptr{Void}, Ptr{Void},), c_async_send, callback_c.handle))
end

function destroy(thread::Thread)
	ccall((:sfThread_destroy, "libcsfml-system"), Void, (Ptr{Void},), thread.ptr)
end

function launch(thread::Thread)
	ccall((:sfThread_launch, "libcsfml-system"), Void, (Ptr{Void},), thread.ptr)
end

function wait(thread::Thread)
	println("Wait")
	ccall((:sfThread_wait, "libcsfml-system"), Void, (Ptr{Void},), thread.ptr)
end

function terminate(thread::Thread)
	ccall((:sfThread_terminate, "libcsfml-system"), Void, (Ptr{Void},), thread.ptr)
end
