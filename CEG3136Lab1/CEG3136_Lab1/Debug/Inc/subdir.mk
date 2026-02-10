################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (13.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../Inc/debug.c 

OBJS += \
./Inc/debug.o 

C_DEPS += \
./Inc/debug.d 


# Each subdirectory must supply rules for building sources it contributes
Inc/%.o Inc/%.su Inc/%.cyclo: ../Inc/%.c Inc/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m33 -std=gnu11 -g3 -DDEBUG -DSTM32L552xx -DSTM32 -DSTM32L5 -DSTM32L552E_EV -DSTM32L552ZETxQ -c -I"C:/Users/mbrom064/STM32CubeIDE/workspace_1.19.0/CEG3136_Lab1/Drivers/CMSIS/Device/ST/STM32L5xx/Include" -I"C:/Users/mbrom064/STM32CubeIDE/workspace_1.19.0/CEG3136_Lab1/Drivers/CMSIS/Include" -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv5-sp-d16 -mfloat-abi=hard -mthumb -o "$@"

clean: clean-Inc

clean-Inc:
	-$(RM) ./Inc/debug.cyclo ./Inc/debug.d ./Inc/debug.o ./Inc/debug.su

.PHONY: clean-Inc

