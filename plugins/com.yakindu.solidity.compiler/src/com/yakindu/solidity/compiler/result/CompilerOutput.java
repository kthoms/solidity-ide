/**
 * Copyright (c) 2017 committers of YAKINDU and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 * 
 * Contributors:
 * 	Andreas Muelder - Itemis AG - initial API and implementation
 * 	Karsten Thoms   - Itemis AG - initial API and implementation
 * 	Florian Antony  - Itemis AG - initial API and implementation
 * 	committers of YAKINDU 
 * 
 */
package com.yakindu.solidity.compiler.result;

import java.util.List;
import java.util.Map;

/**
 * 
 * @author Florian Antony - Initial contribution and API
 *
 */
public class CompilerOutput {

	List<CompileError> errors;
	Map<String, CompiledSource> sources;
	Map<String, Map<String, CompiledContract>> contracts;

	public List<CompileError> getErrors() {
		return errors;
	}

	public void setErrors(List<CompileError> errors) {
		this.errors = errors;
	}

	public Map<String, CompiledSource> getSources() {
		return sources;
	}

	public void setSources(Map<String, CompiledSource> sources) {
		this.sources = sources;
	}

	public Map<String, Map<String, CompiledContract>> getContracts() {
		return contracts;
	}

	public void setContracts(Map<String, Map<String, CompiledContract>> contracts) {
		this.contracts = contracts;
	}

}
