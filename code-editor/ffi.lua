FFI = {
  shell32 = ffi.load('shell32.dll')
}

ffi.cdef([[
  typedef int BOOL;
  typedef int INT;
  typedef const char* LPCSTR;
  typedef unsigned long DWORD;
  typedef void* LPVOID;

  struct HINSTANCE{ int unused; };
  struct HWND{ int unused; };

  typedef struct _SECURITY_ATTRIBUTES {
    DWORD  nLength;
    LPVOID lpSecurityDescriptor;
    BOOL   bInheritHandle;
  } SECURITY_ATTRIBUTES, *PSECURITY_ATTRIBUTES, *LPSECURITY_ATTRIBUTES;

  typedef struct HINSTANCE *HINSTANCE;
  typedef struct HWND *HWND;

  BOOL CreateDirectoryA(LPCSTR lpPathName, LPSECURITY_ATTRIBUTES lpSecurityAttributes);
  HINSTANCE ShellExecuteA(HWND hwnd, LPCSTR lpOperation, LPCSTR lpFile, LPCSTR lpParameters, LPCSTR lpDirectory, INT nShowCmd);
  DWORD GetFileAttributesA(LPCSTR lpFileName);
]]) 

function FFI:create_directory_a(file_path)
  local empty_attribute = ffi.new("LPSECURITY_ATTRIBUTES")
  ffi.C.CreateDirectoryA(file_path, empty_attribute)
end

function FFI:execute_command(command)
  local nullptr = ffi.new("void*")
  self.shell32.ShellExecuteA(nullptr, 'open', "cmd", "/c "..command, nullptr, 0)
end

function FFI:get_file_attributes_a(file_path)
  return ffi.C.GetFileAttributesA(file_path)
end

function FFI:is_directory(file_path)
  return ffi.C.GetFileAttributesA(file_path) == 16
end

return FFI