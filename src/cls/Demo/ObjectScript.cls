Class Demo.ObjectScript
{

/// Demo of pure ObjectScript Code
/// Invoke with: do ##class(Demo.ObjectScript).Test() in the terminal
ClassMethod Test() As %Integer
{
    set a=42 
    write "It works!",!
    return a
}

/// ObjectScript code calling Python code
/// Invoke with: do ##class(Demo.ObjectScript).HelloWorld() is the terminal
ClassMethod HelloWorld() As %Status
{
    // Set status code to $$$OK
    Set sc = $$$OK
    // Import the Python builtins module
    Set b = ##class(%SYS.Python).Import("builtins")
    // Call the print function
    Do b.print("Hello world")
    // Return status code
    Return sc
}

/// ObjectScript code calling Python code
/// Calling a custom Python module
/// This module must be located in /usr/irissys/mgr/python/sample.py
/// The src/python folder is mapped to /usr/irissys/mgr/python
/// Invoke with: do ##class(Demo.ObjectScript).Hello() is the terminal
ClassMethod Hello() As %Status
{
    Set sc = $$$OK
    Set sm = ##class(%SYS.Python).Import("sample")
    write sm.hello()
    Return sc
}

/// Directly code in Python in an ObjectScript method
/// Invoke with: do ##class(Demo.ObjectScript).MyPythonCode("Peter") is the terminal
ClassMethod MyPythonCode(pName as %String) [ Language = python ]
{
    import datetime
    now = datetime.datetime.now()
    print("Hello " + pName + " it is " + now.strftime("%Y-%m-%d %H:%M:%S"))
}

}