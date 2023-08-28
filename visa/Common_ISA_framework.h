/*========================== begin_copyright_notice ============================

Copyright (C) 2017-2021 Intel Corporation

SPDX-License-Identifier: MIT

============================= end_copyright_notice ===========================*/

#ifndef COMMON_ISA_FRAMEWORK
#define COMMON_ISA_FRAMEWORK

#include <cstdio>
#include <fstream>
#include <list>
#include <map>
#include <sstream>
#include <string>
#include <vector>

#include "Common_ISA.h"
#include "IsaDescription.h"
#include "IsaVerification.h"
#include "Mem_Manager.h"
#include "visa_igc_common_header.h"

#define CISA_INVALID_ADDR_ID -1
#define CISA_INVALID_PRED_ID -1
#define CISA_INVALID_VAR_ID ((unsigned)-1)
#define CISA_INVALID_SURFACE_ID -1
#define CISA_INVALID_SAMPLER_ID -1
#define INVALID_LABEL_ID -1

// reserve p0 for the case of no predication
#define COMMON_ISA_NUM_PREDEFINED_PRED 1

#if 0
#define DEBUG_PRINT_SIZE(msg, value)                                           \
  { std::cout << msg << value << "\n"; }
#define DEBUG_PRINT_SIZE_INSTRUCTION(msg, inst, value)                         \
  { std::cerr << msg << ISA_Inst_Table[inst].str << " : " << value << "\n"; }
#else
#define DEBUG_PRINT_SIZE(msg, value)
#define DEBUG_PRINT_SIZE_INSTRUCTION(msg, inst, value)
#endif

struct attr_gen_struct {
  const char *name;
  bool isInt;
  int value;
  const char *string_val;
  bool attr_set;
};

class VISAKernel;
class VISAKernelImpl;
class CISA_IR_Builder;

namespace CisaFramework {

// Wrapper for CISA_INST that also keeps track of its size in vISA binary.
class CisaInst {
public:
  CisaInst(vISA::Mem_Manager &mem) : m_mem(mem), m_size(0) {
    memset(&m_cisa_instruction, 0, sizeof(CISA_INST));
    m_size = 1; // opcode size
  }

  virtual ~CisaInst() {}

  CISA_INST m_cisa_instruction;
  const VISA_INST_Desc *m_inst_desc;

  int createCisaInstruction(ISA_Opcode opcode, unsigned char exec_size,
                            unsigned char modifier, PredicateOpnd pred,
                            VISA_opnd **opnd, int numOpnds,
                            const VISA_INST_Desc *inst_desc,
                            vISAVerifier *verifier = nullptr);

  int getSize() const { return m_size; }
  CISA_INST *getCISAInst() { return &m_cisa_instruction; }
  const VISA_INST_Desc *getCISAInstDesc() const { return m_inst_desc; }
  void *operator new(size_t sz, vISA::Mem_Manager &m) { return m.alloc(sz); }

private:
  vISA::Mem_Manager &m_mem;
  short m_size;
};

class CisaBinary {
public:
  CisaBinary(CISA_IR_Builder *builder);

  virtual ~CisaBinary() {}

  void initCisaBinary(int numberKernels, int numberFunctions) {
    m_header.kernels =
        (kernel_info_t *)m_mem.alloc(sizeof(kernel_info_t) * numberKernels);
    memset(m_header.kernels, 0, sizeof(kernel_info_t) * numberKernels);

    m_header.functions = (function_info_t *)m_mem.alloc(
        sizeof(function_info_t) * numberFunctions);
    memset(m_header.functions, 0, sizeof(function_info_t) * numberFunctions);

    m_upper_bound_kernels = numberKernels;
    m_upper_bound_functions = numberFunctions;

    m_kernelOffsetLocationsArray = (int *)m_mem.alloc(
        sizeof(int) *
        numberKernels); // array to store offsets of where the offset of kernel
                        // is stored in isa header
    m_kernelInputOffsetLocationsArray =
        (int *)m_mem.alloc(sizeof(int) * numberKernels);
    m_krenelBinaryInfoLocationsArray =
        (int *)m_mem.alloc(sizeof(int) * numberKernels);

    m_functionOffsetLocationsArray = (int *)m_mem.alloc(
        sizeof(int) *
        numberFunctions); // array to store offsets of where the offset of
                          // kernel is stored in isa header

    genxBinariesSize = 0;
  }

  void setMagicNumber(unsigned int v) { m_header.magic_number = v; }
  void setMajorVersion(unsigned char v) { m_header.major_version = v; }
  void setMinorVersion(unsigned char v) { m_header.minor_version = v; }
  unsigned char getMajorVersion() const { return m_header.major_version; }
  unsigned char getMinorVersion() const { return m_header.minor_version; }

  void initKernel(int kernelIndex, VISAKernelImpl *kernel);
  int finalizeCisaBinary();
  int dumpToFile(std::string binFileName);
  int dumpToStream(std::ostream *os);

  void *operator new(size_t sz, vISA::Mem_Manager &m) { return m.alloc(sz); }

  unsigned long getKernelVisaBinarySize(int i) {
    return m_header.kernels[i].size;
  }
  unsigned long getFunctionVisaBinarySize(int i) {
    return m_header.functions[i].size;
  }
  unsigned short getNumberKernels() { return m_header.num_kernels; }
  unsigned short getNumberFunctions() { return m_header.num_functions; }

  char *getVisaHeaderBuffer() { return m_header_buffer; }

  void patchKernel(int index, unsigned int genxBufferSize, void *buffer,
                   int platform);
  void patchFunction(int index, unsigned genxBufferSize);
  void patchFunctionWithGenBinary(int index, unsigned int genxBufferSize,
                                  char *buffer);

  Options *getOptions() { return m_options; }

private:
  /*
      Arrays that store locations (offset from beginning) in isa header buffer
      for offset field, and gen_binary_info data structure
      Will be used later to patch it when genx binaries are generated
  */
  int genxBinariesSize;
  int *m_kernelOffsetLocationsArray; // array to store offsets of where the
                                     // offset of kernel is stored in isa header
  int *m_kernelInputOffsetLocationsArray;
  int *m_krenelBinaryInfoLocationsArray;

  int *m_functionOffsetLocationsArray; // array to store offsets of where the
                                       // offset of kernel is stored in isa
                                       // header
  unsigned long writeInToCisaHeaderBuffer(const void *value, int size);

  common_isa_header m_header;
  vISA::Mem_Manager m_mem;
  uint32_t m_header_size;
  uint32_t m_total_size;
  unsigned long m_bytes_written_cisa_buffer;
  char *m_header_buffer;
  int m_upper_bound_kernels;
  int m_upper_bound_functions;

  Options *m_options;

  CISA_IR_Builder *parent;
};

bool allowDump(const Options &options, const std::string &fileName);

} // namespace CisaFramework
#endif
