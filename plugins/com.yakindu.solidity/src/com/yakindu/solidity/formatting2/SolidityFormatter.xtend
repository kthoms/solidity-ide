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
package com.yakindu.solidity.formatting2

import com.yakindu.solidity.solidity.ArrayTypeSpecifier
import com.yakindu.solidity.solidity.Block
import com.yakindu.solidity.solidity.ConstructorDefinition
import com.yakindu.solidity.solidity.ContractDefinition
import com.yakindu.solidity.solidity.EmitExpression
import com.yakindu.solidity.solidity.EventDefinition
import com.yakindu.solidity.solidity.ExponentialExpression
import com.yakindu.solidity.solidity.ForStatement
import com.yakindu.solidity.solidity.FunctionDefinition
import com.yakindu.solidity.solidity.IfStatement
import com.yakindu.solidity.solidity.ImportDirective
import com.yakindu.solidity.solidity.MappingTypeSpecifier
import com.yakindu.solidity.solidity.ModifierDefinition
import com.yakindu.solidity.solidity.NamedArgument
import com.yakindu.solidity.solidity.NewInstanceExpression
import com.yakindu.solidity.solidity.NumericalUnaryExpression
import com.yakindu.solidity.solidity.PragmaDirective
import com.yakindu.solidity.solidity.SimpleArgument
import com.yakindu.solidity.solidity.SolidityModel
import com.yakindu.solidity.solidity.SourceUnit
import com.yakindu.solidity.solidity.StructDefinition
import com.yakindu.solidity.solidity.TupleExpression
import com.yakindu.solidity.solidity.VariableDefinition
import com.yakindu.solidity.solidity.WhileStatement
import org.eclipse.xtext.formatting2.AbstractFormatter2
import org.eclipse.xtext.formatting2.IFormattableDocument
import org.eclipse.xtext.formatting2.IHiddenRegionFormatter
import org.yakindu.base.expressions.expressions.AssignmentExpression
import org.yakindu.base.expressions.expressions.BitwiseAndExpression
import org.yakindu.base.expressions.expressions.BitwiseOrExpression
import org.yakindu.base.expressions.expressions.BitwiseXorExpression
import org.yakindu.base.expressions.expressions.ConditionalExpression
import org.yakindu.base.expressions.expressions.FeatureCall
import org.yakindu.base.expressions.expressions.LogicalAndExpression
import org.yakindu.base.expressions.expressions.LogicalNotExpression
import org.yakindu.base.expressions.expressions.LogicalOrExpression
import org.yakindu.base.expressions.expressions.LogicalRelationExpression
import org.yakindu.base.expressions.expressions.NumericalAddSubtractExpression
import org.yakindu.base.expressions.expressions.NumericalMultiplyDivideExpression
import org.yakindu.base.expressions.expressions.PostFixUnaryExpression
import org.yakindu.base.expressions.expressions.ShiftExpression
import org.yakindu.base.types.EnumerationType

/**
 * Code formatter for Solidity according to 
 * <a href="http://solidity.readthedocs.io/en/develop/style-guide.html">Solidity Styleguide</a>.
 * 
 * @author Karsten Thoms - Initial contribution and API
 * @author Florian Antony
 */
class SolidityFormatter extends AbstractFormatter2 {

	def dispatch void format(SolidityModel it, extension IFormattableDocument document) {
		sourceunit.forEach[format]

	}

	def dispatch void format(SourceUnit it, extension IFormattableDocument document) {
		imports.forEach[format]

		allRegionsFor.keywordPairs('[', ']').forEach [
			key.append[noSpace]
			value.prepend[noSpace]
		]
		allRegionsFor.keywordPairs('(', ')').forEach [
			key.append[noSpace]
			value.prepend[noSpace]
		]
		pragma.forEach[format]
		member.forEach[format]
		append[noSpace]
	}

	def dispatch void format(PragmaDirective it, extension IFormattableDocument document) {
		prepend[noSpace]
	}

	def dispatch void format(ImportDirective it, extension IFormattableDocument document) {
		prepend[newLines]
	}

	def dispatch void format(ContractDefinition it, extension IFormattableDocument document) {
		interior[indent]
		regionFor.keywordPairs('{', '}').forEach [
			key.append[newLine; priority = IHiddenRegionFormatter.LOW_PRIORITY;].prepend[oneSpace]
			value.surround[newLines; priority = IHiddenRegionFormatter.LOW_PRIORITY;]
		]

		regionFor.keyword("is").surround[oneSpace]
		allRegionsFor.keywordPairs('(', ')').forEach [
			key.append[noSpace]
			value.prepend[noSpace]
		]
		features.forEach[format]
	}

	def dispatch void format(VariableDefinition it, extension IFormattableDocument document) {
		prepend[newLines]
		initialValue.format
	}

	def dispatch void format(ConstructorDefinition it, extension IFormattableDocument document) {
		prepend[newLines(2, 2, 3)]
		allRegionsFor.keywords("constructor", ",").forEach [
			append[oneSpace]
		]
		allRegionsFor.keywordPairs('(', ')').forEach [
			key.append[noSpace]
			value.prepend[noSpace]
		]
		modifier.forEach [
			prepend[oneSpace]
		]
		block.format
	}

	def dispatch void format(FunctionDefinition it, extension IFormattableDocument document) {
		prepend[newLines(2, 2, 3)]
		regionFor.keyword(",").append[oneSpace].prepend[noSpace]
		allRegionsFor.keywordPairs('(', ')').forEach [
			key.append[noSpace]
			value.prepend[noSpace]
		]
		parameters.forEach [
			p | p.typeSpecifier.append[oneSpace; priority = IHiddenRegionFormatter.HIGH_PRIORITY;]
		]
		modifier.forEach [
			prepend[oneSpace]
		]
		block.format
	}

	def dispatch void format(MappingTypeSpecifier it, extension IFormattableDocument document) {
		prepend[newLines(2, 2, 3)]
		regionFor.keyword("mapping").append[oneSpace]
		regionFor.keyword("'=>").surround[oneSpace]
		allRegionsFor.keywordPairs('(', ')').forEach [
			key.append[noSpace]
			value.prepend[noSpace]
		]
	}

	def dispatch void format(ArrayTypeSpecifier it, extension IFormattableDocument document) {
		prepend[newLines]
		allRegionsFor.keywordPairs('[', ']').forEach [
			key.append[noSpace]
			value.prepend[noSpace]
		]
	}

	def dispatch void format(ModifierDefinition it, extension IFormattableDocument document) {
		prepend[newLines(2, 2, 3)]
		regionFor.keyword("modifier").append[oneSpace]
		regionFor.keyword(",").append[oneSpace].prepend[noSpace]
		allRegionsFor.keywordPairs('(', ')').forEach [
			key.append[noSpace]
			value.prepend[noSpace]
		]
		block.format
	}

	def dispatch void format(EventDefinition it, extension IFormattableDocument document) {
		prepend[newLines]
	}

	def dispatch void format(EnumerationType it, extension IFormattableDocument document) {
		prepend[newLines(2, 2, 3)]
		interior[indent]
		regionFor.keyword("enum").append[oneSpace]
		regionFor.keywordPairs('{', '}').forEach [
			key.append[newLines].prepend[oneSpace]
			value.surround[newLines; priority = IHiddenRegionFormatter.LOW_PRIORITY;]
		]
		enumerator.forEach[prepend[newLines]]
	}

	def dispatch void format(StructDefinition it, extension IFormattableDocument document) {
		prepend[newLines(2, 2, 3)]
		interior[indent]
		regionFor.keyword("struct").append[oneSpace]
		regionFor.keywordPairs('{', '}').forEach [
			key.append[newLines].prepend[oneSpace]
			value.surround[newLines; priority = IHiddenRegionFormatter.LOW_PRIORITY;]
		]
		features.forEach[prepend[newLines]]
	}

	def dispatch void format(Block it, extension IFormattableDocument document) {
		interior[indent]
		regionFor.keywordPairs('{', '}').forEach [
			key.append[newLines]
			key.prepend[oneSpace]
			value.prepend[noSpace]
		]

		statements.forEach[format; prepend[noSpace]; append[newLines()];]
	}

	def dispatch void format(AssignmentExpression it, extension IFormattableDocument document) {
		allSemanticRegions.forEach [ region |
			if (it.operator.literal == region.text) {
				region.surround[oneSpace]
			}
		]
	}

	def dispatch void format(ConditionalExpression it, extension IFormattableDocument document) {
		allRegionsFor.keywords("?", ":").forEach[surround[oneSpace]]
		trueCase.format
		falseCase.format
	}

	def dispatch void format(LogicalOrExpression it, extension IFormattableDocument document) {
		regionFor.keyword("||").surround[oneSpace]
		leftOperand.format
		rightOperand.format
	}

	def dispatch void format(LogicalAndExpression it, extension IFormattableDocument document) {
		regionFor.keyword("&&").surround[oneSpace]
		leftOperand.format
		rightOperand.format
	}

	def dispatch void format(LogicalNotExpression it, extension IFormattableDocument document) {
		regionFor.keyword("!").surround[noSpace; priority = IHiddenRegionFormatter.LOW_PRIORITY;]
		operand.format
	}

	def dispatch void format(LogicalRelationExpression it, extension IFormattableDocument document) {
		allSemanticRegions.forEach [ region |
			if (it.operator.literal == region.text) {
				region.surround[oneSpace]
			}
		]
		leftOperand.format
		rightOperand.format
	}

	def dispatch void format(BitwiseOrExpression it, extension IFormattableDocument document) {
		regionFor.keyword("|").surround[oneSpace]
		leftOperand.format
		rightOperand.format
	}

	def dispatch void format(BitwiseXorExpression it, extension IFormattableDocument document) {
		regionFor.keyword("^").surround[oneSpace]
		leftOperand.format
		rightOperand.format
	}

	def dispatch void format(BitwiseAndExpression it, extension IFormattableDocument document) {
		regionFor.keyword("&").surround[oneSpace]
		leftOperand.format
		rightOperand.format
	}

	def dispatch void format(ShiftExpression it, extension IFormattableDocument document) {
		allSemanticRegions.forEach [ region |
			if (it.operator.literal == region.text) {
				region.surround[oneSpace]
			}
		]
		leftOperand.format
		rightOperand.format
	}

	def dispatch void format(NumericalAddSubtractExpression it, extension IFormattableDocument document) {
		allSemanticRegions.forEach [ region |
			if (it.operator.literal == region.text) {
				region.surround[oneSpace]
			}
		]
		leftOperand.format
		rightOperand.format
	}

	def dispatch void format(NumericalMultiplyDivideExpression it, extension IFormattableDocument document) {
		allSemanticRegions.forEach [ region |
			if (it.operator.literal == region.text) {
				region.surround[oneSpace]
			}
		]
		leftOperand.format
		rightOperand.format
	}

	def dispatch void format(ExponentialExpression it, extension IFormattableDocument document) {
		regionFor.keyword("**").surround[oneSpace]
		leftOperand.format
		rightOperand.format
	}

	def dispatch void format(NumericalUnaryExpression it, extension IFormattableDocument document) {
		allSemanticRegions.forEach [ region |
			if (it.operator.literal == region.text) {
				region.surround[oneSpace]
			}
		]
		operand.format
	}

	def dispatch void format(PostFixUnaryExpression it, extension IFormattableDocument document) {
		allSemanticRegions.forEach [ region |
			if (it.operator.literal == region.text) {
				region.surround[noSpace]
			}
		]
		operand.format
	}

	def dispatch void format(NewInstanceExpression it, extension IFormattableDocument document) {
		regionFor.keyword("new").append[oneSpace]
		regionFor.keyword(",").append[oneSpace].prepend[noSpace]
		allRegionsFor.keywordPairs('(', ')').forEach [
			key.append[noSpace]
			value.prepend[noSpace]
		]
		operationCall.format

	}

	def dispatch void format(EmitExpression it, extension IFormattableDocument document) {
		regionFor.keyword("emit").append[oneSpace]
		regionFor.keyword(",").append[oneSpace].prepend[noSpace]
		allRegionsFor.keywordPairs('(', ')').forEach [
			key.append[noSpace]
			value.prepend[noSpace]
		]
		operationCall.format

	}

	def dispatch void format(TupleExpression it, extension IFormattableDocument document) {
		regionFor.keyword(",").append[oneSpace].prepend[noSpace]
		allRegionsFor.keywordPairs('(', ')').forEach [
			key.append[noSpace]
			value.prepend[noSpace]
		]
		allRegionsFor.keywordPairs('[', ']').forEach [
			key.append[noSpace]
			value.prepend[noSpace]
		]
		expressions.forEach[format]
	}

	def dispatch void format(FeatureCall it, extension IFormattableDocument document) {
		regionFor.keyword(".").surround[noSpace]
		regionFor.keyword(",").append[oneSpace].prepend[noSpace]
		allRegionsFor.keywordPairs('(', ')').forEach [
			key.append[noSpace]
			value.prepend[noSpace]
		]
		allRegionsFor.keywordPairs('[', ']').forEach [
			key.append[noSpace]
			value.prepend[noSpace]
		]
		arguments.forEach[format]
		expressions.forEach[format]
		arraySelector.forEach[format]
	}

	def dispatch void format(IfStatement it, extension IFormattableDocument document) {
		regionFor.keyword("if").append[oneSpace]
		regionFor.keyword("else").surround[oneSpace; priority = IHiddenRegionFormatter.HIGH_PRIORITY]
		condition.format
		then.format
		^else.format
		append[newLines()]
	}

	def dispatch void format(WhileStatement it, extension IFormattableDocument document) {
		regionFor.keyword("while").append[oneSpace]
		condition.format
		body.format
		append[newLines()]
	}

	def dispatch void format(ForStatement it, extension IFormattableDocument document) {
		regionFor.keyword("for").append[oneSpace]
		initialization.prepend[noSpace]
		condition.format
		afterthought.prepend[noSpace]
		statement.format
		append[newLines]
	}

	def dispatch void format(SimpleArgument it, extension IFormattableDocument document) {
		prepend[oneSpace; priority = IHiddenRegionFormatter.LOW_PRIORITY]
		append[noSpace; priority = IHiddenRegionFormatter.LOW_PRIORITY]
		value.format
	}

	def dispatch void format(NamedArgument it, extension IFormattableDocument document) {
		regionFor.keyword(":").surround[oneSpace]
		surround[oneSpace; priority = IHiddenRegionFormatter.LOW_PRIORITY]
		value.format
	}

	protected def void newLines(IHiddenRegionFormatter it) {
		newLines(1, 2, 3)
	}

	protected def void newLines(IHiddenRegionFormatter it, int lines) {
		newLines(1, lines, 3)
	}

	protected def void newLines(IHiddenRegionFormatter it, int min, int lines, int max) {
		noSpace
		setNewLines(min, lines, max)
	}

}
