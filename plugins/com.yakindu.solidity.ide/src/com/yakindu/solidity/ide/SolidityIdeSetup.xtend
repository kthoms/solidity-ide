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
package com.yakindu.solidity.ide

import com.google.inject.Guice
import com.yakindu.solidity.SolidityRuntimeModule
import com.yakindu.solidity.SolidityStandaloneSetup
import com.yakindu.solidity.ide.internal.CustomContentAssistService
import com.yakindu.solidity.ide.internal.SolidityIdeModule
import org.eclipse.xtext.ide.server.contentassist.ContentAssistService
import org.eclipse.xtext.util.Modules2

/**
 * Initialization support for running Xtext languages as language servers.
 */
class SolidityIdeSetup extends SolidityStandaloneSetup {

	override createInjector() {
		Guice.createInjector(Modules2.mixin(new SolidityRuntimeModule, new SolidityIdeModule))
	}
}
