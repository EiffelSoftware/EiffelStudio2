

class PROJECT_CONTEXT


inherit
	SYSTEM_CONSTANTS;
	SHARED_WORKBENCH

feature {NONE} -- Status report

	Project_read_only: BOOLEAN_REF is
			-- Is the project only usable for browing and debugging
			-- (no compilation)?
		once
			!! Result
		end;

	is_project_readable: BOOLEAN is
			-- May the project be used for browsing and debugging?
		do
			Result :=
				(Update_file.exists and then Update_file.is_readable) and then
				System.server_controler.is_readable
		end;

	is_project_writable: BOOLEAN is
			-- May the project be both compiled and used for browsing?
		local
			w_code_dir, f_code_dir, comp_dir: RAW_FILE;
			project_file: RAW_FILE
		do
			!! w_code_dir.make (Workbench_generation_path);
			!! f_code_dir.make (Final_generation_path);
			!! comp_dir.make (Compilation_path);
			!! project_file.make (Project_file_name);
			Result := project_file.is_writable and then
				Update_file.exists and then
				(Update_file.is_readable and Update_file.is_writable) and then
				(w_code_dir.exists and then w_code_dir.is_writable) and then
				(f_code_dir.exists and then f_code_dir.is_writable) and then
				(f_code_dir.exists and then comp_dir.is_writable) and then
				System.server_controler.is_writable
		end;

feature {NONE}

	Update_file: RAW_FILE is
			-- File containing all the byte code to update
		once
			!!Result.make (build_path (Workbench_generation_path, Updt))
		end;

	Project_directory: PROJECT_DIR is
			-- Shared project directory
		once
			Result := init_project_directory
		end;

	Precompilation_directory: PROJECT_DIR is
			-- Shared precompilation directory
		once
			Result := init_precompilation_directory
		end;

	init_project_directory: PROJECT_DIR is do end;
	init_precompilation_directory: PROJECT_DIR is do end;

	Project_directory_name: STRING is
		once
			Result := Project_directory.name
		end;

	Case_storage_path: STRING is
		once
			!!Result.make (0);
			Result.append (Case_gen_path);
			Result.extend (Directory_separator);
			Result.append (Case_storage);
		end;

	Case_gen_path: STRING is
		once
			!!Result.make (Project_directory_name.count + 8);
			Result.append (Project_directory_name);
			Result.extend (Directory_separator);
			Result.append (Casegen);
		end;

	Create_case_storage_directory is
		local
			d: DIRECTORY
		do
			!!d.make (Case_gen_path);
			if not d.exists then
				d.create
			end;
			!!d.make (Case_storage_path);
			if not d.exists then
				d.create
			end;
		end;

	Eiffel_gen_path: STRING is
		once
			!!Result.make (Project_directory_name.count + 11);
			Result.append (Project_directory_name);
			Result.append (Eiffelgen_rel_path);
		end;

	Create_eiffel_gen_directory is
		local
			d: DIRECTORY
		once
			!!d.make (Eiffel_gen_path);
			if not d.exists then
				d.create
			end;
		end;

	Workbench_generation_path: STRING is
		once
			!!Result.make (Project_directory_name.count + 18);
			Result.append (Project_directory_name);
			Result.append (W_code_rel_path)
		end;

	Final_generation_path: STRING is
		once
			!!Result.make (Project_directory_name.count + 7);
			Result.append (Project_directory_name);
			Result.append (F_code_rel_path)
		end;

	Create_generation_directory is
		local
			d: DIRECTORY
		once
			Create_eiffel_gen_directory;
			!!d.make (Final_generation_path);
			if not d.exists then
				d.create
			end;
			!!d.make (Workbench_generation_path);
			if not d.exists then
				d.create
			end;
		end;

	Compilation_path: STRING is
			-- Path to the compilation directory
		once
			!!Result.make (Project_directory_name.count + 16);
			Result.append (Project_directory_name);
			Result.append (Comp_rel_path)
		end;

	Create_compilation_directory is
			-- Directory where the compilation files are generated
		local
			d: DIRECTORY
		once
			Create_eiffel_gen_directory;
			!!d.make (compilation_path);
			if not d.exists then
				d.create
			end
		end;

	Project_file_name: STRING is
			-- Full name of the file where the workbench is stored
		once
			!!Result.make (Project_directory_name.count + 21);
			Result.append (Project_directory_name);
			Result.append (workb_rel_path)
		end;

	Precompilation_path: STRING is
			-- Path to the precompilation directory
		once
			!!Result.make (Precompilation_directory.name.count + 16);
			Result.append (Precompilation_directory.name);
			Result.append (Comp_rel_path)
		end;

	Precompilation_file_name: STRING is
			-- Full name of the file where the precompiled 
			-- workbench is stored
		once
			!!Result.make (Precompilation_directory.name.count + 22);
			Result.append (Precompilation_directory.name);
			Result.append (workb_rel_path)
		end;

	Precompilation_preobj: STRING is
			-- Full name of the `preobj' object file
		once
			!!Result.make (Precompilation_directory.name.count + 22);
			Result.append (Precompilation_directory.name);
			Result.append (Preobj_rel_path)
		end;

	Precompilation_driver: STRING is
			-- Full name of the `preobj' object file
		once
			!!Result.make (Precompilation_directory.name.count + 22);
			Result.append (Precompilation_directory.name);
			Result.append (Driver_rel_path)
		end;

feature {NONE} -- Relative paths

	build_path (path, base_name: STRING): STRING is
		do
			!!Result.make (0);
			Result.append (path);
			Result.extend (Directory_separator);
			Result.append (base_name);
		end;

	Eiffelgen_rel_path: STRING is
			-- "/EIFFELGEN"
		once
			Result := build_path ("", Eiffelgen);
		end;

	workb_rel_path: STRING is
			-- "/EIFFELGEN/.workbench"
		once
			Result := build_path (Eiffelgen_rel_path, Dot_workbench);
		end;

	Comp_rel_path: STRING is
			-- "/EIFFELGEN/COMP"
		once
			Result := build_path (Eiffelgen_rel_path, Comp);
		end;

	W_code_rel_path: STRING is
			-- "/EIFFELGEN/W_code"
		once
			Result := build_path (Eiffelgen_rel_path, W_code);
		end;

	F_code_rel_path: STRING is
			-- "/EIFFELGEN/F_code"
		once
			Result := build_path (Eiffelgen_rel_path, F_code);
		end;

	Driver_rel_path: STRING is
			-- "/EIFFELGEN/W_code/driver"
		once
			Result := build_path (W_code_rel_path, Driver);
		end;

	Preobj_rel_path: STRING is
			-- "/EIFFELGEN/W_code/preobj.o"
		once
			Result := build_path (W_code_rel_path, Preobj);
		end;

end
