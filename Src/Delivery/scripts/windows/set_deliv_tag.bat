@echo off
set STUDIO_VERSION_MAJOR_MINOR=%1
set DEFAULT_PUBLIC_SVN=https://svn.eiffel.com/eiffelstudio/tags/Eiffel_%STUDIO_VERSION_MAJOR_MINOR%
set DEFAULT_ISE_SVN=svn://svn.ise/ise_svn/tags/Eiffel_%STUDIO_VERSION_MAJOR_MINOR%

echo Version: %STUDIO_VERSION_MAJOR_MINOR%
echo Public subversion: %DEFAULT_PUBLIC_SVN%
echo ISE    subversion: %DEFAULT_ISE_SVN%
