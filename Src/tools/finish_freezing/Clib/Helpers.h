// <copyright file="Helpers.h" company="Microsoft Corporation">
// Copyright (C) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt in the project root for license information.
// </copyright>

#pragma once

#define __nameof(x) L#x

struct ModuleDeleter
{
	void operator()(_In_ HMODULE* phModule)
	{
		if (phModule && *phModule)
		{
			::FreeLibrary(*phModule);
		}
	}
};

typedef std::unique_ptr<HMODULE, ModuleDeleter> module_ptr;

struct SafeArrayDeleter
{
	void operator()(_In_ LPSAFEARRAY* ppsa)
	{
		if (ppsa && *ppsa)
		{
			if ((*ppsa)->cLocks)
			{
				::SafeArrayUnlock(*ppsa);
			}

			::SafeArrayDestroy(*ppsa);
		}
	}
};

typedef std::unique_ptr<LPSAFEARRAY, SafeArrayDeleter> safearray_ptr;

class win32_exception :
	public std::exception
{
public:
	win32_exception(_In_ DWORD code, _In_z_ const char* what) :
		std::exception(what),
		m_code(code)
	{
	}

	win32_exception(_In_ const win32_exception& obj) :
		std::exception(obj)
	{
		m_code = obj.m_code;
	}

	DWORD code() const
	{
		return m_code;
	}

private:
	DWORD m_code;
};

class CoInitializer
{
public:
	CoInitializer()
	{
		hr = ::CoInitialize(NULL);
		if (FAILED(hr))
		{
			throw win32_exception(hr, "failed to initialize COM");
		}
	}

	~CoInitializer()
	{
		if (SUCCEEDED(hr))
		{
			::CoUninitialize();
		}
	}

private:
	HRESULT hr;
};
